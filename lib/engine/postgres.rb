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

    def search(query)
      explained = db[:movies].where("content @@ ?", query)
        .order(Sequel.lit("ts_rank_cd(content, '#{query}') DESC"))
        .explain(analyze: true)

      explained.scan(/\d+\.\d+ ms/).map(&:to_f).inject(:+)
    end

    private

    def create_table
      db.create_table :movies do
        primary_key :id

        column :title,   :varchar
        column :year,    :integer
        column :plot,    :text
        column :episode, :varchar

        column :content, :tsvector
      end

      db.run <<-SQL
        CREATE FUNCTION movies_trigger() RETURNS trigger AS $$
        begin
          new.content :=
             setweight(to_tsvector(coalesce(new.title,'')), 'A') ||
             setweight(to_tsvector(coalesce(new.year::text,'')), 'A')  ||
             setweight(to_tsvector(coalesce(new.plot,'')), 'B')  ||
             setweight(to_tsvector(coalesce(new.episode,'')), 'C');
          return new;
        end
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER movies_tsv BEFORE INSERT OR UPDATE
        ON movies FOR EACH ROW EXECUTE PROCEDURE movies_trigger();
      SQL

      db.run "CREATE INDEX movies_search ON movies USING gin(content)"
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
