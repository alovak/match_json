require 'spec_helper'

describe "match_json" do
  it 'aliased to include_json' do
    expect(match_json("{}").base_matcher).to be_a(include_json("{}").class)
  end
end
