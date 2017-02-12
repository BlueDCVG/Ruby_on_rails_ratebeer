require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "When given, is registered to the beer and user who is signed in" do
    doARating

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "Should not have any before been created" do
    visit ratings_path
    expect(page).to have_content 'List of ratings'
    expect(page).to have_content 'Number of ratings: 0'
  end

  it "Should show many ratings done" do
    doARating
    click_button "Create Rating"
    doARating
    click_button "Create Rating"
    doARating
    click_button "Create Rating"


    visit ratings_path
    expect(page).to have_content 'List of ratings'
    expect(page).to have_content 'Number of ratings: 3'
  end

end

def doARating
  visit new_rating_path
  select('iso 3', from:'rating[beer_id]')
  fill_in('rating[score]', with:'15')
end
