
module MatchJson
  module Matchers
    class IncludeJson
      PATTERNS = {
        'date_time_iso8601' => /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/,
        'date' => /^\d{4}-\d{2}-\d{2}/,
        'uuid' => /\h{32}/,
        'email' => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,6}\z/i,
        'string' => /\A.+\z/i
      }

      def initialize(expected_json)
        @expected_json = JSON.parse(expected_json.gsub(/(?<!")(\{\w+\})(?!")/, '"\1:non-string"'))
      end

      def matches?(actual_json)
        @actual_json = actual_json.respond_to?(:body) ? JSON.parse(actual_json.body) : JSON.parse(actual_json)

        catch(:match) { json_included?(@actual_json, @expected_json) }
      end

      def failure_message
        @failure_message
      end

      def failure_message_when_negated
        "does not support negation"
      end

      private

      def json_included?(actual, expected)
        equal_value?(actual, expected)
      end

      def hash_included?(actual, expected, nested, raise_error)
        if compared_different_types?(actual, expected)
          @failure_message = %Q(Different types of compared elements:\n #{actual.class} for #{actual.to_json}\nand #{expected.class} for #{expected.to_json})
          throw(:match, false)
        end

        expected.each do |key, value|
          if (!equal_value?(actual[key], value, "#{nested} > #{key}", raise_error))
            @failure_message = %Q("#{key}":#{value.to_json} was not found in\n #{actual.to_json})

            if raise_error
              throw(:match, false)
            else
              return false
            end
          end
        end
      end

      def array_included?(actual, expected, nested, raise_error)
        expected.each do |value|
          if actual.nil? || (!actual.any? { |actual_value| equal_value?(actual_value, value, nested, false) })
            @failure_message = %Q("#{value.to_json}" was not found in\n )
            @failure_message << %Q("#{nested}":) if !nested.empty?
            @failure_message << "#{actual.to_json}"

            if raise_error
              throw(:match, false)
            else
              return false
            end
          end
        end
      end

      def equal_value?(actual, expected, nested = '', raise_error = true)
        case expected
        when Array then array_included?(actual, expected, nested, raise_error)
        when Hash then hash_included?(actual, expected, nested, raise_error)
        when String then compare_with_pattern(expected, actual)
        else
          actual == expected
        end
      end

      def compare_with_pattern(value, actual)
        case
        when regexp?(value)
          reg_exp = value.match(/{re:(.*)}/)[1]
          actual =~ Regexp.new(reg_exp)
        when defined_regexp?(value)
          defined_regexps = PATTERNS.keys.find_all { |pattern| pattern.is_a? Regexp }
          matches = value.match(/{(\w+):(\w+)}/)
          reg_exp = defined_regexps.find {|re| re.match("#{matches[1]}:#{matches[2]}") }
          PATTERNS[reg_exp].call(actual, matches[2])
        when pattern?(value)
          actual =~ PATTERNS["#{value.tr('{}', '')}"]
        when non_string_pattern?(value) && !actual.is_a?(String)
          actual.to_s =~ PATTERNS["#{value.tr('{}', '').sub(':non-string', '')}"]
        else
          value == actual
        end
      end

      def pattern?(str)
        !!(str =~ /\A\{\w+\}\z/)
      end

      def non_string_pattern?(str)
        !!(str =~ /\A\{\w+\}:non-string\z/)
      end

      def regexp?(str)
        !!(str =~ /\A\{re:.+\}\z/)
      end

      def defined_regexp?(str)
        !!(str =~ /\A\{\w+:\w+\}\z/)
      end

      def compared_different_types?(actual, expected)
        actual.class != expected.class
      end
    end
  end
end
