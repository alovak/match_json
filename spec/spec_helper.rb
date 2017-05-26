require 'match_json/rspec'
require 'byebug'

Dir['./spec/support/**/*'].each do |f|
  require f.sub(%r{\./spec/}, '')
end

RSpec.configure do |config|
  config.include RSpec::Matchers::FailMatchers
end
