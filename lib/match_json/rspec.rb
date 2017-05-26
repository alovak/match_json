require 'match_json'

RSpec.configure do |config|
  config.include MatchJson::Matchers
end

RSpec::Matchers.alias_matcher :match_json, :include_json
