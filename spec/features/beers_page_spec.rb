require 'rails_helper'

describe "Beer creation" do
  it "should not have any before been created" do
    visit beers_path
    expect(page).to have_content 'Listing beers'
    expect(page).to have_content 'Number of beers: 0'
  end

  it "should let you create a beer with a name" do
    FactoryGirl.create :brewery, name:"Koff"
    visit new_beer_path
    fill_in('beer_name', with:'weard')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "Should not let you create a beer with no name" do
    visit new_beer_path
    expect{click_button('Create Beer')}.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"
  end
end
