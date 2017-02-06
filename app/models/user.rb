class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30}
  validates :password, length: { minimum: 4 }

  has_secure_password

  validate :password, :includes_one_number
  validate :password, :includes_one_capital


  def includes_one_number
    if not password =~ /\d/
      errors.add(:password, "has to contain atleast one number!")
    end
  end

  def includes_one_capital
    if not password =~ /[A-Z]/
      errors.add(:password, "has to contain atleast one capital letter!")
    end
  end

end
