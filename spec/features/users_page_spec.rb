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
end

describe "User is able to" do
  let(:user){FactoryGirl.create(:user) }
  before :each do
    beer = FactoryGirl.create(:beer)
    rating = FactoryGirl.create(:rating, score:10,  beer:beer)
    rating2 = FactoryGirl.create(:rating, score:20,  beer:beer)
    user.ratings << rating
    user.ratings << rating2
  end


it "see their own ratings" do
  visit user_path(user)

  expect(user.ratings.count).to eq(2)
  expect(page).to have_content 'anonymous, anonymous, 10'
  expect(page).to have_content 'anonymous, anonymous, 20'
  end

  it "not to see others ratings" do
    user1 = FactoryGirl.create(:user, username:"Matti")
    visit user_path(user1)

    expect(user.ratings.count).to eq(2)
    expect(page).to have_content 'Has made 0 ratings.'
    end

  it "delete own ratings" do
    sign_in(username:"Pekka", password:"Foobar1")
    visit user_path(user)

    expect{page.all('a')[page.all('a').count - 4].click}.to change{Rating.count}.by(-1)
  end


  it "show their favourite beer style and favourite brewery" do
    visit user_path(user)
    
    expect(page).to have_content 'By average favourite brewery: anonymous'
    expect(page).to have_content 'By average favourite beer style: Lager'
  end
end
