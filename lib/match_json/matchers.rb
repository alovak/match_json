require 'match_json/matchers/include_json'

module MatchJson
  module Matchers
    def include_json(json)
      MatchJson::Matchers::IncludeJson.new(json)
    end
  end
end

RSpec.configure do |config|
  config.include MatchJson::Matchers
end

RSpec::Matchers.alias_matcher :match_json, :include_json
