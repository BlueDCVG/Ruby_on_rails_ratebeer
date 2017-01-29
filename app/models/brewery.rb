class Brewery < ActiveRecord::Base
  has_many :beers

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
