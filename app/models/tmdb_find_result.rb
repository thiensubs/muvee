class TmdbFindResult < ExternalMetadata

  TMDB_API_KEY = "a533c4925884599fa704aaf5a9006983"

  def result_format
    :json
  end

  def self.endpoint_url(imdb_id)
    "https://api.themoviedb.org/3/find/#{imdb_id}?api_key=#{TMDB_API_KEY}&external_source=imdb_id"
  end

end
