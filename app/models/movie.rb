class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.by_director(movie)
    self.where(:director => movie.director)
  end

end
