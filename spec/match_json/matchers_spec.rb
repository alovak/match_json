require 'spec_helper'

describe MatchJson::Matchers do
  context 'when json is object' do
    it 'matches when json included' do
      actual_json = <<-JSON
      {
        "one": 1,
        "two": 2
      }
      JSON

      expect(actual_json).to include_json(<<-JSON)
      {
        "one": 1
      }
      JSON
    end

    it 'does not match when json is not included' do
      actual_json = <<-JSON
      {
        "one": 1
      }
      JSON

      expect {
        expect(actual_json).to include_json(<<-JSON)
        {
          "one": 2
        }
        JSON
      }.to fail_with(%Q("one"=>2 was not found in\n {"one"=>1}))
    end
  end

  context 'when json is array' do
    it 'matches when json included' do
      expect(%Q([1, 2, 3])).to include_json(%Q([3, 2]))
      expect(%Q([1, 2, 3])).to include_json(%Q([1, 2, 3]))
    end

    it 'does not match when json is not included' do
      expect {
        expect(%Q([1, 2, 3])).to include_json(%Q([3, 5]))
      }.to fail_with(%Q("5" was not found in\n [1, 2, 3]))
    end
  end

  context 'when object contains array' do
    it 'matches' do
      expect(%Q({ "array" : [1, 2, 3] })).to include_json(%Q({ "array" : [3, 2, 1] }))
    end

    it 'does not match' do
      expect {
        expect(%Q({ "array" : [1, 2, 3] })).to include_json(%Q({ "array" : [5, 1] }))
      }.to fail_with(%Q("5" was not found in\n " > array"=>[1, 2, 3]))
    end
  end

  context 'when array contains object' do
    it 'matches' do
      expect(%Q([ { "one": 1 }, { "two": 2 }])).to include_json(%Q([ { "one": 1 }]))
    end

    it 'does not match' do
      expect {
        expect(%Q([ { "one": 1 }, { "two": 2 }])).to include_json(%Q([ { "one": 2 }]))
      }.to fail_with(%Q(\"{"one"=>2}\" was not found in\n [{"one"=>1}, {"two"=>2}]))
    end
  end

  context 'when structure is multilevel' do
    it 'does not match' do
      expect {
        expect(%Q([ { "one": { "array": [1,2,3] } } ])).to include_json(%Q([ { "one": { "array": [1,2,3,4] } } ]))
      }.to fail_with(%Q("{"one"=>{"array"=>[1, 2, 3, 4]}}" was not found in\n [{"one"=>{"array"=>[1, 2, 3]}}]))
    end
  end
end
