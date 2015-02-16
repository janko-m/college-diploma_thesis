require "typhoeus/adapters/faraday"
require "elasticsearch"

class Engine
  class Elasticsearch < Engine
    def setup
      create_index
    end

    def clear
      client.indices.delete_mapping index: "diploma", type: "movie"
    end

    def import(movies)
      client.bulk index: "diploma", type: "movie",
        body: movies.map { |movie| {create: {data: movie}} }
    end

    def search(query)
      response = client.search index: "diploma", body: {
        query: {
          match: {_all: query},
        }
      }
      response.fetch("took")
    end

    private

    def create_index
      client.indices.delete index: "diploma" if client.indices.exists index: "diploma"
      client.indices.create index: "diploma", body: {
        mappings: {
          movie: {
            # properties: {
            #   title:   {type: "string",  index: "analyzed"},
            #   year:    {type: "integer", index: "analyzed"},
            #   plot:    {type: "string",  index: "analyzed"},
            #   episode: {type: "string",  index: "analyzed"},
            # }
          }
        }
      }
    end

    def client
      @client ||= ::Elasticsearch::Client.new host: "127.0.0.1:9200"
    end
  end
end
