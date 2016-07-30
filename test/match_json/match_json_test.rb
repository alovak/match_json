require 'test_helper'

describe "match_json" do
  it 'aliased to include_json' do
    expect(match_json("{}")).must_be_kind_of(include_json("{}").class)
  end
end
