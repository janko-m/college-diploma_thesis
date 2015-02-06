source "https://rubygems.org"

gem "sinatra", "~> 1.4"
gem "rake"

gem "sinatra-activerecord", ">= 2.0.5"
gem "activerecord", "~> 4.2"
gem "pg"

# Full-text search engines
gem "sunspot"               # Solr
gem "thinking-sphinx"       # Sphinx
gem "pg_search", "~> 0.7.9" # Postgres
gem "elasticsearch"         # Elasticsearch

group :development, :test do
  gem "pry"
end

group :test do
  gem "cucumber"
  gem "minitest"
  gem "rack-test"
  gem "database_cleaner"
end
