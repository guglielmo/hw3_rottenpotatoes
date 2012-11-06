class Movie < ActiveRecord::Base
  class Movie::InvalidKeyError < StandardError ; end

  def self.api_key
    '22ac67d843029d55fc2b4959c4f908b3' # replace with YOUR Tmdb key
  end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.find_in_tmdb(string)
    Tmdb.api_key = self.api_key
    begin
      TmdbMovie.find(:title => string)
    rescue ArgumentError => tmdb_error
      raise Movie::InvalidKeyError, tmdb_error.message
    rescue RuntimeError => tmdb_error
      if tmdb_error.message =~ /status code '404'/
        raise Movie::InvalidKeyError, tmdb_error.message
      else
        raise RuntimeError, tmdb_error.message
      end
    end
  end
end
