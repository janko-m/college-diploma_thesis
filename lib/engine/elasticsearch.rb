require "typhoeus/adapters/faraday"
require "elasticsearch"
require "active_support/core_ext/hash/keys"

class Engine
  class Elasticsearch < Engine
    def setup
      create_index
    end

    def clear
      client.indices.delete_mapping index: "diploma", type: "movie"
    end

    def import(movies)
      client.bulk index: "diploma", type: "movie", refresh: true,
        body: movies.map { |movie| {create: {data: movie}} }
    end

    def search(query, page: nil, per_page: nil, highlight: nil, **options)
      options.each do |key, value|
        query << " #{key}:(#{value})"
      end
      params = {
        query: {
          query_string: {
            query: query,
            default_operator: "AND",
            fields: ["title^4", "year^4", "plot^2", "episode^2"],
          }
        }
      }
      params.merge!(from: page - 1, size: per_page) if per_page
      params.merge!(highlight: {pre_tags: ["<strong>"], post_tags: ["</strong>"], fields: {title: {}}}) if highlight

      response = client.search index: "diploma", type: "movie", body: params
      response["hits"]["hits"].map do |hash|
        if hash["highlight"]
          attributes = Hash[hash["highlight"].map { |k, v| [k, v.first] }]
        else
          attributes = hash["_source"]
        end
        attributes.symbolize_keys
      end
    end

    private

    def create_index
      client.indices.delete index: "diploma" if client.indices.exists index: "diploma"
      client.indices.create index: "diploma", body: {
        settings: {
          analysis: {
            filter: {
              stopwords: {type: "stop", stopwords: ["a"]},
              stemming:  {type: "stemmer_override", rules: ["chairs=>chair"]},
              synonyms:  {type: "synonym", synonyms: ["magazine,journal"]},
            },
            analyzer: {
              default: {
                tokenizer: "standard",
                filter: [
                  "lowercase",
                  "stopwords",
                  "stemming",
                  "synonyms",
                  "asciifolding",
                ]
              }
            }
          }
        },
        mappings: {
          movie: {
          }
        }
      }
    end

    def client
      @client ||= ::Elasticsearch::Client.new host: "127.0.0.1:9200"
    end
  end
end
