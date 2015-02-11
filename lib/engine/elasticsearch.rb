require "patron"
require "elasticsearch"

class Engine
  class Elasticsearch < Engine
    def import(movies)
      create_index
      add(movies)
    end

    private

    def add(movies)
      client.bulk index: "diploma", type: "movie",
        body: movies.map { |movie| {create: {body: movie}} }
    end

    def create_index
      client.indices.delete index: "diploma" if client.indices.exists index: "diploma"
      client.indices.create index: "diploma"
    end

    def client
      @client ||= ::Elasticsearch::Client.new host: "127.0.0.1:9200"
    end
  end
end
