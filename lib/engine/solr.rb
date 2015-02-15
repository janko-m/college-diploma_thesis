require "rsolr"

class Engine
  class Solr < Engine
    def setup
    end

    def clear
      client.delete_by_query "*:*"
    end

    def import(movies)
      client.add movies.map.with_index { |movie, id|
        {
          id:               id,
          title_s:          movie.fetch(:title),
          year_i:           movie.fetch(:year),
          plot_t:           movie.fetch(:plot),
          episode_name_s:   movie.fetch(:episode_name),
          episode_number_i: movie.fetch(:episode_number),
          season_number_i:  movie.fetch(:season_number),
        }
      }
    end

    private

    def client
      @client ||= RSolr.connect
    end
  end
end
