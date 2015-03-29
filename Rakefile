require "pry"

$LOAD_PATH.unshift("./lib")
require "engine"

$engines = [
  Engine::Postgres.new,
  Engine::Elasticsearch.new,
  Engine::Solr.new,
  Engine::Sphinx.new,
]

import "tasks/setup.rake",
       "tasks/import.rake",
       "tasks/compare.rake"
