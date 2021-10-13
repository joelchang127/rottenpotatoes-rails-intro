class Movie < ActiveRecord::Base

  def self.all_ratings
    @all_ratings = Movie.distinct.pluck(:rating)
  end
  
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    if ratings_list.nil?
      @movies = Movie.all
    else
      @movies = Movie.where(rating: ratings_list)
    end
  end
  
end
