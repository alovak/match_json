require 'match_json/matchers/include_json'

module MatchJson
  module Matchers
    def include_json(json)
      MatchJson::Matchers::IncludeJson.new(json)
    end
  end
end
