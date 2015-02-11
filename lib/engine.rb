class Engine
  autoload :Postgres,      "engine/postgres"
  autoload :Elasticsearch, "engine/elasticsearch"
  autoload :Solr,          "engine/solr"
  autoload :Sphinx,        "engine/sphinx"

  def import(movies)
    raise NotImplementedError
  end
end
