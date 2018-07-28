# MatchJSON [![Code Climate](https://codeclimate.com/github/WhitePayments/match_json/badges/gpa.svg)](https://codeclimate.com/github/WhitePayments/match_json)

![Match JSON](assets/match.png "Match JSON")

Test your JSON in RSpec, MiniTest or Cucumber, like a boss.

> The **only** matcher I let my kids play with 
> -- Mom

## Getting Started

Ever since the dawn of mankind, humans everywhere have been searching for a tool to test their JSON. 

Then computers were invented.

Then matchJSON came about.

Then everyone lived happily ever after.

*Stop warping your brain with hard-to-read regex and weird-looking tests.*

**The old, yucky way:**
```ruby
it "returns the current pony" do
  get "/ponies/#{pony.id}"

  current_pony = JSON.parse(response.body)["pony"]
  expect(current_pony["cuteness"]).to eq 90
  expect(current_pony["fluffiness"]).to eq "extra-fluffy"
  expect(current_pony["name"]).to eq "McPony"
end
```

**The new, cool way:**
```ruby
it "returns the current pony" do
  get "/ponies/#{pony.id}"

  expect(response).to match_json(<<-JSON)
  {
    "cuteness": 90,
    "fluffiness": "extra-fluffy",
    "name": "McPony",
  }
  JSON
end
```

Wait, you already use **[JSON-Schema](https://github.com/ruby-json-schema/json-schema)**? We're BFFs :heart:

```ruby
it "returns the current pony" do
  get "/ponies/#{pony.id}"

  # JSON-Schema to check the schema
  expect(response).to match_response_schema(:pony)

  # MatchJSON to test the values (gotta love explicit tests)
  expect(response).to match_json(<<-JSON)
  {
    "cuteness": 90,
    "fluffiness": "extra-fluffy",
    "name": "McPony",
  }
  JSON
end
```

## Installation

- Drop this baby into your Gemfile like so:

```ruby
gem 'match_json'
```

- Run `bundle`

### Rspec

In spec_helper.rb or rails_helper.rb include library as following:

```
require 'match_json/rspec'
```

###

In minitest's test_helper.rb add this:

```
require 'match_json/minitest'
```

## Advanced usage


### Patterns

Add some patterns in the mix to make things interesting:

```ruby
# RSpec
it 'returns ponies' do
  get '/ponies/#{pony.id}'

  expect(response).to match_json(<<-JSON)
  {
    "id": "{uuid}", # UUID Pattern
    "cuteness": 90,
    "fluffiness": "extra-fluffy",
    "name": "McPony",
    "created_at": "{date_time_iso8601}" # DateTime pattern (well, duh)
  }
  JSON
end
```

Here's a list of the built-in patterns we provide:
* `date_time_iso8601`
* `date`
* `uuid`
* `email`
* `string`

### Define your own patterns

Just add them to `spec/support/match_json.rb`:

```ruby
MatchJson::Matchers::IncludeJson::PATTERNS['id'] = /\A\d{6}\z/
MatchJson::Matchers::IncludeJson::PATTERNS[/id:(\w+)'] = proc { |actual, match| /\A#{match}_\z/ =~ actual }
```

and then use it in your spec like so:

```ruby
it 'uses patten to check value' do

  # MatchJson::Matchers::IncludeJson::PATTERNS['id'] = /\A\d{6}\z/
  expect(%Q({"one": "123456"})).to match_json(%Q({"one": "{id}"}))
  # .. you can even do this:
  expect(%Q({"one": 123456})).to match_json(%Q({"one": {id}}))

  # MatchJson::Matchers::IncludeJson::PATTERNS[/id:(\w+)'] = proc { |actual, match| /\A#{match}_\z/ =~ actual }
  expect(%Q({"id": "usr_xxx"})).to match_json(%Q({"one": "{id:usr}"}))
  expect(%Q({"id": "cus_xxx"})).to match_json(%Q({"one": "{id:cus}"}))
end
```

## Contributing

1. Fork it ( https://github.com/[your-github-username]/match_json/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
