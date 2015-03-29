require "riddle"
require "riddle/2.1.0"
require "mysql2"
require "sequel"

class Engine
  class Sphinx < Engine
    def setup
      controller.stop
      create_database
      create_table
    end

    def clear
      db[:movies].delete
    end

    def import(movies)
      controller.stop
      movies.each_slice(1_000) do |slice|
        db[:movies].multi_insert(slice)
      end
      controller.index
      controller.start
    end

    def search(query)
      limit = db[:movies].count
      sphinx_db[:movies].where("MATCH(?)", query).limit(limit).to_a
    end

    private

    def create_database
      mysql = Mysql2::Client.new(username: "root")
      mysql.query("DROP DATABASE IF EXISTS diploma")
      mysql.query("CREATE DATABASE diploma")
    end

    def create_table
      db.create_table :movies do
        primary_key :id

        column :title,   :varchar
        column :year,    :integer
        column :plot,    :text
        column :episode, :varchar
      end
    end

    def controller
      @controller ||= Riddle::Controller.new(configuration, config_path)
    end

    def configuration
      @configuration ||= Riddle::Configuration.new.tap do |configuration|
        source = Riddle::Configuration::SQLSource.new('movies', 'mysql')
        source.sql_host       = "127.0.0.1"
        source.sql_user       = "root"
        source.sql_pass       = ""
        source.sql_db         = "diploma"
        source.sql_port       = "3306"
        source.sql_query      = "SELECT * FROM movies"
        source.sql_range_step = 1_000

        index = Riddle::Configuration::Index.new("movies")
        index.sources      = [source]
        index.path         = "/usr/local/var/data/index"
        index.docinfo      = "extern"
        configuration.indices << index

        configuration.searchd.address     = "127.0.0.1"
        configuration.searchd.mysql41     = 9306
        configuration.searchd.workers     = "threads"
        configuration.searchd.pid_file    = File.expand_path("tmp/sphinx.pid")
        configuration.searchd.log         = File.expand_path("tmp/searchd.log")
        configuration.searchd.query_log   = File.expand_path("tmp/searchd.query.log")
        configuration.searchd.binlog_path = nil

        File.write(config_path, configuration.render)
      end
    end

    def config_path
      File.expand_path("data/sphinx.conf")
    end

    def db
      @db ||= Sequel.connect("mysql2://root@localhost/diploma")
    end

    def sphinx_db
      @sphinx_db ||= Sequel.connect("mysql2://root@127.0.0.1:9306/diploma")
    end

    def client
      @client ||= Riddle::Client.new
    end
  end
end
