# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'match_json/version'

Gem::Specification.new do |spec|
  spec.name          = "match_json"
  spec.version       = MatchJson::VERSION
  spec.authors       = ["Pavel Gabriel", "White Payments"]
  spec.email         = ["alovak@gmail.com"]
  spec.summary       = %q{RSpec matcher for JSON documents}
  spec.description   = %q{Easily test your JSON in RSpec and Cucumber.}
  spec.homepage      = "https://github.com/WhitePayments/match_json"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", ">= 3.0", "< 4.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-matchers", "~> 1.4"
  spec.add_development_dependency "minitest-byebug"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
