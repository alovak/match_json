require 'match_json'

class Minitest::Test
  include MatchJson::Matchers

  alias_method :match_json, :include_json
end
