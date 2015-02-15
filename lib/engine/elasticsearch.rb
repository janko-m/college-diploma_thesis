require "patron"
require "elasticsearch"

class Engine
  class Elasticsearch < Engine
    def setup
      create_index
    end

    def clear
      client.delete_by_query index: "diploma", type: "movie",
        body: {query: {match_all: {}}}
    end

    def import(movies)
      client.bulk index: "diploma", type: "movie",
        body: movies.map { |movie| {create: {body: movie}} }
    end

    private

    def create_index
      client.indices.delete index: "diploma" if client.indices.exists index: "diploma"
      client.indices.create index: "diploma"
    end

    def client
      @client ||= ::Elasticsearch::Client.new host: "127.0.0.1:9200"
    end
  end
end
