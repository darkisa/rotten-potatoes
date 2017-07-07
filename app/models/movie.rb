class Movie < ActiveRecord::Base

  def self.get_ratings
    uniq.pluck(:rating)
  end

  def self.sort_and_filter(title, ratings)
    if title && !ratings.empty?
      all.where(rating: ratings).order(title)
    else all
    end
  end

end
