require "riddle"
require "riddle/2.1.0"
require "mysql2"
require "sequel"

class Engine
  class Sphinx < Engine
    def import(movies)
      create_database
      create_table
      start
      add(movies)
    end

    private

    def add(movies)
      db[:movies].multi_insert(movies)
    end

    def create_database
      mysql = Mysql2::Client.new(username: "root")
      mysql.query("DROP DATABASE IF EXISTS diploma")
      mysql.query("CREATE DATABASE diploma")
    end

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

    def start
      controller.start
      at_exit { controller.stop }
    end

    def controller
      @controller ||= Riddle::Controller.new(configuration, config_path)
    end

    def configuration
      full_text_fields = %w[title year plot episode_name]
      attributes       = %w[episode_number season_number]

      @configuration ||= Riddle::Configuration.new.tap do |configuration|
        source = Riddle::Configuration::SQLSource.new('movies', 'mysql')
        source.sql_host      = "localhost"
        source.sql_user      = "root"
        source.sql_db        = "diploma"
        source.sql_port      = "3306"
        source.sql_query     = "SELECT * FROM movies"
        source.sql_attr_uint = attributes
        configuration.sources << source

        index = Riddle::Configuration::RealtimeIndex.new("movies")
        index.path         = "/usr/local/var/data/movies_rt"
        index.rt_field     = full_text_fields
        index.rt_attr_uint = attributes
        configuration.indices << index

        configuration.searchd.listen    = "127.0.0.1:9306"
        configuration.searchd.workers   = "threads"
        configuration.searchd.pid_file  = File.expand_path("tmp/sphinx.pid")
        configuration.searchd.log       = File.expand_path("tmp/searchd.log")
        configuration.searchd.query_log = File.expand_path("tmp/searchd.query.log")
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

    def client
      @client ||= Riddle::Client.new
    end
  end
end
