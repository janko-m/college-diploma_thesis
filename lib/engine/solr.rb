require "rsolr"

class Engine
  class Solr < Engine
    def import(movies)
      clear_data
      add(movies)
    end

    private

    def add(movies)
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

    def clear_data
      client.delete_by_query "*:*"
    end

    def client
      @client ||= RSolr.connect
    end
  end
end
