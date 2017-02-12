require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "Is saved with name and style" do
    beer = Beer.create name:"kalja", style: "IPA"
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "Is not saved without name" do
    beer = Beer.create style: "IPA"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "Is not saved without style" do
    beer = Beer.create name:"kalja"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
