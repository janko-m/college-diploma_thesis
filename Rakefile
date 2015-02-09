require "sinatra/activerecord/rake"

ActiveRecord::Base.schema_format = :sql
ActiveRecord::Base.timestamped_migrations = false

namespace :db do
  task :load_config do
    require_relative "app"
  end
end
