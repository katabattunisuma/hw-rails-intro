class Movie < ActiveRecord::Base
end
def self.all_ratings
        return ['G','PG','PG-13','R']
end

    def self.with_ratings(all_ratings, sort_by)
        movies = Movie.where(:rating => all_ratings).order(sort_by)
        return movies 
    end
 