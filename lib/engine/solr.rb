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
          episode_s:        movie.fetch(:episode),
        }
      }
    end

    def search(query)
      response = client.get "select", params: {q: "*:*"}
      response["responseHeader"].fetch("QTime")
    end

    private

    def client
      @client ||= RSolr.connect
    end
  end
end
