require 'rails_helper'

RSpec.describe User, type: :model do
  it "Has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "Is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "With a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score:10
      rating2 = Rating.new score:20

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "Is not saved without proper password" do
    user = User.create username:"Jakeskuukkeli", password:"salasana", password_confirmation:"salasana"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "Favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "Has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "Without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "Is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "Is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "Favorite beer style" do
    let(:user){FactoryGirl.create(:user) }

    it "Has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "Without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "Is the only rated if only one rating" do
      bestStyle = create_beer_with_rating(user, 25)
      expect(user.favorite_beer).to eq(bestStyle)
    end

    it "Is the one with highest average ratings if several rated" do
      create_beers_with_ratings(user, 10, 20, 15)
      create_beers_with_ratings2style(user, 30, 40, 35)

      expect(user.favorite_style).to eq("IPA")
    end
  end
end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating(user, score)
  end
end

def create_beers_with_ratings2style(user, *scores)
  scores.each do |score|
    create_beer_with_rating2style(user, score)
  end
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
  beer
end

def create_beer_with_rating2style(user, score)
  beer = FactoryGirl.create(:beer, style:"IPA")
  FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
  beer
end
