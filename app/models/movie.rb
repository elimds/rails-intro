class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date
  
  def self.all_ratings
    r = Array.new
    i = 0
    self.select('DISTINCT rating').each do |value|
      r[i] = value.rating
      i += 1
    end
    return r
  end
  
end
