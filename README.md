# MatchJSON [![Code Climate](https://codeclimate.com/github/WhitePayments/match_json/badges/gpa.svg)](https://codeclimate.com/github/WhitePayments/match_json)

![Match JSON](match.png "Match JSON")

Test your JSON in RSpec and Cucumber, like a boss.

> The **only** matches I let my kids play with 
> -- Mom

## Getting Started

Ever since the dawn of mankind, humans everywhere have been searching for a tool to test their JSON. 

Then computers were invented.

Then matchJSON came about.

Then everyone lived happily ever after.

*Stop warping your brain with hard-to-read regex and weird-looking tests.*


```ruby
# The old, yucky way
it "returns the current pony" do
  get "/ponies/#{pony.id}"

  current_pony = JSON.parse(response.body)["pony"]
  expect(current_pony["cuteness""]).to eq 90
  expect(current_pony["fluffiness""]).to eq "extra-fluffy"
  expect(current_pony["name"]).to eq "McPony"
end

# The new, cool way
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

Already using **[JSON-Schema](https://github.com/ruby-json-schema/json-schema)**? We're BFFs :heart:

```ruby
# You're a super star

it "returns the current pony" do
  get "/ponies/#{pony.id}"

  # Some JSON-Schema love to check the schema
  expect(response).to match_response_schema(:charge)

  # MatchJSON to test the values (explicit is AWESOME)
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


## Advanced action

You can add some patterns in the mix to make things interesting:

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


## Usage: RSpec

In RSpec we add this matcher: ```include_json```

So you can use it as follows:

```ruby
it 'returns charge' do
  get '/charges/#{charge.id}'

  expect(response).to include_json(<<-JSON)
  {
    "id": "{uuid}",
    "amount": 100,
    "currency": "USD",
    "created_at": "{date_time_iso8601}"
  }
  JSON
end

it 'returns list of charges' do
  get '/charges'

  expect(response).to include_json(<<-JSON)
  {
    "charges": [
      {
        "id": "{uuid}",
        "amount": 100,
        "currency": "USD",
        "created_at": "{date_time_iso8601}"
      }
    ]
  }
  JSON
end
```

As you can see for cases when you do not know the value of some properties like
```id``` or ```created_at``` or even ```email``` you can use 'pattern' instead.

You can use the following predefined patterns:

* date_time_iso8601
* date
* uuid
* email
* string

You also can add your own pattern. Just add into spec/support/match_json.rb your
new patterns:

```ruby
MatchJson::Matchers::IncludeJson::PATTERNS['id'] = /\A\d{6}\z/
```

and then use it in your spec:

```ruby
it 'uses patten to check value' do
  expect(%Q({"one": "123456"})).to include_json(%Q({"one": "{id}"}))
  # you can do even this:
  expect(%Q({"one": 123456})).to include_json(%Q({"one": {id}}))
end
```

## Installation

Or install it yourself as:

    $ gem install match_json

## Contributing

1. Fork it ( https://github.com/[my-github-username]/match_json/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
