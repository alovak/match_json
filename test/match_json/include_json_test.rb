require 'test_helper'

describe "include_json" do
  it 'passes when object is partially included' do
    expect(%Q({ "one": 1, "two": 2 })).must include_json(%Q({ "one": 1 }))
  end

  it "fails when expected object is not included" do
    err = expect {
      expect(%Q({ "one": 1 })).must include_json(%Q({ "one": 2 }))
    }.must_raise(Exception)
    err.message.must_equal(%Q("one":2 was not found in\n {"one":1}.))
  end

  it 'passes when array is partially included' do
    expect(%Q([1,2,3])).must include_json(%Q([3,2]))
    expect(%Q([1,2,3])).must include_json(%Q([1,2,3]))
  end

  it 'fails when there is no such array' do
    err = expect {
      expect(%Q([1,2,3])).must include_json(%Q([3,5]))
    }.must_raise(Exception)
    err.message.must_equal(%Q("5" was not found in\n [1,2,3].))
  end

  describe 'when object contains array' do
    it 'passes when array included' do
      expect(%Q({ "array" : [1,2,3] })).must include_json(%Q({ "array" : [3,2,1] }))
    end

    it 'fails with there is no such array' do
      err = expect {
        expect(%Q({ "array" : [1,2,3] })).must include_json(%Q({ "array" : [5,1] }))
      }.must_raise(Exception)
      err.message.must_equal(%Q("5" was not found in\n " > array":[1,2,3].))
    end

    it 'fails with there is null instead of array' do
      err = expect {
        expect(%Q({ "array" : null })).must include_json(%Q({ "array" : [5] }))
      }.must_raise(Exception)
      err.message.must_equal(%Q("5" was not found in\n " > array":null.))
    end
  end

  describe 'when array contains object' do
    it 'passes when object included in array' do
      expect(%Q([ { "one": 1 }, { "two": 2 }])).must include_json(%Q([ { "one": 1 }]))
    end

    it 'fails when there is no such object in array' do
      err1 = expect {
        expect(%Q([ { "one": 1 }, { "two": 2 }])).must include_json(%Q([ { "one": 2 }]))
      }.must_raise(Exception)
      err1.message.must_equal(%Q(\"{"one":2}\" was not found in\n [{"one":1},{"two":2}].))

      err2 = expect {
        expect(%Q({ "array" : null })).must include_json(%Q({ "array" : [5] }))
      }.must_raise(Exception)
      err2.message.must_equal(%Q("5" was not found in\n " > array":null.))
    end
  end

  describe 'in multilevel structure' do
    it 'fails if object was not found' do
      err = expect {
        expect(%Q([ { "one": { "array": [1,2,3] } } ])).must include_json(%Q([ { "one": { "array": [1,2,3,4] } } ]))
      }.must_raise(Exception)
      err.message.must_equal(%Q("{"one":{"array":[1,2,3,4]}}" was not found in\n [{"one":{"array":[1,2,3]}}].))
    end
  end

  describe 'when ckeck for inclusion of different types' do
    it 'fails with clean message' do
      err = expect {
        expect(%Q([ { "one": 1 } ])).must include_json(%Q({ "one": 1 }))
      }.must_raise(Exception)
      err.message.must_equal(%Q(Different types of compared elements:\n Array for [{"one":1}]\nand Hash for {"one":1}.))
    end
  end

  describe 'with pattern' do
    it 'passes when value matches pattern' do
      expect(%Q({"one": "test@exmaple.com"})).must include_json(%Q({"one": "{email}"}))
      expect(%Q({"one": "2020-12-22"})).must include_json(%Q({"one": "{date}"}))
    end
  end

  describe 'with custom pattern' do
    before do
      MatchJson::Matchers::IncludeJson::PATTERNS['id'] = /\A\d{6}\z/
    end

    after do
      MatchJson::Matchers::IncludeJson::PATTERNS.delete('id')
    end

    it 'uses patten to check value' do
      expect(%Q({"one": "123456"})).must include_json(%Q({"one": "{id}"}))
      expect(%Q({"one": 123456})).must include_json(%Q({"one": {id}}))
      expect(%Q({"one": "123456"})).wont include_json(%Q({"one": {id}}))

      err1 = expect {
        expect(%Q({"one": "abcdef"})).must include_json(%Q({"one": "{id}"}))
      }.must_raise(Exception)
      err1.message.must_equal(%Q("one":"{id}" was not found in\n {"one":"abcdef"}.))

      err2 = expect {
        expect(%Q({"one": true})).must include_json(%Q({"one": {id}}))
      }.must_raise(Exception)
      err2.message.must_equal(%Q("one":"{id}:non-string" was not found in\n {"one":true}.))
    end
  end
end
