require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "Who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "When signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "sees their ratings" do
    visit user_path(user)
    
    rating = Rating.new score:10
    rating2 = Rating.new score:20

    user.ratings << FactoryGirl.create(:rating)
    user.ratings << FactoryGirl.create(:rating2)

    save_and_open_page
    expect(user.ratings.count).to eq(2)
    expect(page).to have_content 'isonenä'

  end
end
