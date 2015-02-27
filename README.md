# MatchJson
[![Code Climate](https://codeclimate.com/github/WhitePayments/match_json/badges/gpa.svg)](https://codeclimate.com/github/WhitePayments/match_json)

Easily test your JSON in RSpec and Cucumber.

This matcher can't be the only tool when you test your JSON. We also
recommend to use [json-schema](https://github.com/ruby-json-schema/json-schema)
as a perfect companion to MatchJson.

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
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'match_json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install match_json

## Contributing

1. Fork it ( https://github.com/[my-github-username]/match_json/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
