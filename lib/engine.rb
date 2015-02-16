class Engine
  autoload :Postgres,      "engine/postgres"
  autoload :Elasticsearch, "engine/elasticsearch"
  autoload :Solr,          "engine/solr"
  autoload :Sphinx,        "engine/sphinx"

  def name
    self.class.name
  end

  def setup
    raise NotImplementedError
  end

  def clear
    raise NotImplementedError
  end

  def import(movies)
    raise NotImplementedError
  end

  def search(query)
    raise NotImplementedError
  end

  def index(movie)
    raise NotImplementedError
  end
end
