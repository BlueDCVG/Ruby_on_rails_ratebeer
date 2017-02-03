class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                      only_integer: true }
  validate :year, :not_in_the_future

  def not_in_the_future
    if year > Time.now.year
        errors.add(:year, "can't be in the future")
    end
  end


  def print_report
    puts name
    puts "Established at year #{year}"
    puts "Number of beers #{beers.count}"
  end

  def restart
    self.year = 2017
    puts "Changed year to #{year}"
  end
end
