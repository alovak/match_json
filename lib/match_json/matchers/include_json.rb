
module MatchJson
  module Matchers
    class IncludeJson
      def initialize(expected_json)
        @expected_json = JSON.parse(expected_json)
      end

      def matches?(actual_json)
        @actual_json = JSON.parse(actual_json)

        match = catch(:match) { json_included?(@actual_json, @expected_json) }
        # @actual, @expected = scrub(actual_json, @path), scrub(@expected_json)
        # @actual == @expected
      end

      def failure_message
        @failure_message
      end

      def failure_message_when_negated
        "does not support negation"
      end

      private

      def json_included?(actual, expected)
        case actual
        when Hash then hash_included?(actual, expected)
        when Array then array_included?(actual, expected)
        end

        true
      end

      def hash_included?(actual, expected)
        expected.each do |key, value|
          if (actual[key] != value)
            @failure_message = %Q("#{key}"=>#{value} was not found in\n #{actual})

            throw :match, false
          end
        end
      end

      def array_included?(actual, expected)
        expected.each do |value|
          if (!actual.include?(value))
            @failure_message = %Q("#{value}" was not found in\n #{actual})

            throw :match, false
          end
        end
      end
    end
  end
end
