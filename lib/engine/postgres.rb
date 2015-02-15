require "pg"
require "sequel"

class Engine
  class Postgres < Engine
    def setup
      create_database
      create_table
    end

    def clear
      db[:movies].delete
    end

    def import(movies)
      db[:movies].multi_insert(movies)
    end

    private

    def create_table
      db.create_table :movies do
        column :title,          :varchar
        column :year,           :integer
        column :plot,           :text
        column :episode_name,   :varchar
        column :episode_number, :integer
        column :season_number,  :integer
      end
    end

    def create_database
      pg = PG.connect
      pg.exec "DROP DATABASE IF EXISTS diploma"
      pg.exec "CREATE DATABASE diploma"
    end

    def db
      @db ||= Sequel.connect("postgres:///diploma")
    end
  end
end
