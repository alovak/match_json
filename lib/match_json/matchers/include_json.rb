
module MatchJson
  module Matchers
    class IncludeJson
      def initialize(expected_json)
        @expected_json = JSON.parse(expected_json)
      end

      def matches?(actual_json)
        @actual_json = JSON.parse(actual_json)

        match = catch(:match) { json_included?(@actual_json, @expected_json) }
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
        expected.each do |key, value|
          if (!equal_value?(actual[key], value, "#{nested} > #{key}", raise_error))
            @failure_message = %Q("#{key}"=>#{value} was not found in\n #{actual})

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
          if (!actual.any? { |actual_value| equal_value?(actual_value, value, nested, false) })
            @failure_message = %Q("#{value}" was not found in\n )
            @failure_message << %Q("#{nested}"=>) if !nested.empty?
            @failure_message << "#{actual}"

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
        else
          actual == expected
        end
      end
    end
  end
end
