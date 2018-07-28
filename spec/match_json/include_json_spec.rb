require 'spec_helper'

describe "include_json" do
  it 'passes when object is partially included' do
    expect(%Q({ "one": 1, "two": 2 })).to include_json(%Q({ "one": 1 }))
  end

  it "fails when expected object is not included" do
    expect {
      expect(%Q({ "one": 1 })).to include_json(%Q({ "one": 2 }))
    }.to fail_with(%Q("one":2 was not found in\n {"one":1}))
  end

  it 'passes when array is partially included' do
    expect(%Q([1,2,3])).to include_json(%Q([3,2]))
    expect(%Q([1,2,3])).to include_json(%Q([1,2,3]))
  end

  it 'fails when there is no such array' do
    expect {
      expect(%Q([1,2,3])).to include_json(%Q([3,5]))
    }.to fail_with(%Q("5" was not found in\n [1,2,3]))
  end

  context 'when object contains array' do
    it 'passes when array included' do
      expect(%Q({ "array" : [1,2,3] })).to include_json(%Q({ "array" : [3,2,1] }))
    end

    it 'fails with there is no such array' do
      expect {
        expect(%Q({ "array" : [1,2,3] })).to include_json(%Q({ "array" : [5,1] }))
      }.to fail_with(%Q("5" was not found in\n " > array":[1,2,3]))
    end

    it 'fails with there is null instead of array' do
      expect {
        expect(%Q({ "array" : null })).to include_json(%Q({ "array" : [5] }))
      }.to fail_with(%Q("5" was not found in\n " > array":null))
    end
  end

  context 'when array contains object' do
    it 'passes when object included in array' do
      expect(%Q([ { "one": 1 }, { "two": 2 }])).to include_json(%Q([ { "one": 1 }]))
    end

    it 'fails when there is no such object in array' do
      expect {
        expect(%Q([ { "one": 1 }, { "two": 2 }])).to include_json(%Q([ { "one": 2 }]))
      }.to fail_with(%Q(\"{"one":2}\" was not found in\n [{"one":1},{"two":2}]))
    end
  end

  context 'in multilevel structure' do
    it 'fails if object was not found' do
      expect {
        expect(%Q([ { "one": { "array": [1,2,3] } } ])).to include_json(%Q([ { "one": { "array": [1,2,3,4] } } ]))
      }.to fail_with(%Q("{"one":{"array":[1,2,3,4]}}" was not found in\n [{"one":{"array":[1,2,3]}}]))
    end
  end

  context 'when ckeck for inclusion of different types' do
    it 'fails with clean message' do
      expect {
        expect(%Q([ { "one": 1 } ])).to include_json(%Q({ "one": 1 }))
      }.to fail_with(%Q(Different types of compared elements:\n Array for [{"one":1}]\nand Hash for {"one":1}))
    end
  end

  context 'with pattern' do
    it 'passes when value matches pattern' do
      expect(%Q({"one": "test@exmaple.com"})).to include_json(%Q({"one": "{email}"}))
      expect(%Q({"one": "2020-12-22"})).to include_json(%Q({"one": "{date}"}))
    end
  end

  context 'with custom pattern' do
    before do
      MatchJson::Matchers::IncludeJson::PATTERNS['id'] = /\A\d{6}\z/
    end

    after do
      MatchJson::Matchers::IncludeJson::PATTERNS.delete('id')
    end

    it 'uses patten to check value' do
      expect(%Q({"one": "123456"})).to include_json(%Q({"one": "{id}"}))
      expect(%Q({"one": 123456})).to include_json(%Q({"one": {id}}))
      expect(%Q({"one": "123456"})).not_to include_json(%Q({"one": {id}}))

      expect {
        expect(%Q({"one": "abcdef"})).to include_json(%Q({"one": "{id}"}))
      }.to fail_with(%Q("one":"{id}" was not found in\n {"one":"abcdef"}))
      expect {
        expect(%Q({"one": true})).to include_json(%Q({"one": {id}}))
      }.to fail_with(%Q("one":"{id}:non-string" was not found in\n {"one":true}))
    end
  end

  context 'with custom pattern as regexp' do
    let(:regexp) { /id:(\w+)/ }
    before do
      MatchJson::Matchers::IncludeJson::PATTERNS[regexp] = proc { |actual, match| /\A#{match}_\w+\z/ =~ actual }
    end

    after do
      MatchJson::Matchers::IncludeJson::PATTERNS.delete(regexp)
    end

    it 'uses patten to check value' do
      expect(%Q({"one": "cus_xxx"})).to include_json(%Q({"one": "{id:cus}"}))
      expect(%Q({"one": "cust_xxx"})).to_not include_json(%Q({"one": "{id:cus}"}))
    end
  end
end
