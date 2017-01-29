class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    return 0 if ratings.empty?
    ratings.map{|r| r.score }.sum/ratings.count
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
