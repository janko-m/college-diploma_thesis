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

    def search(query, page: nil, per_page: nil, highlight: nil, **options)
      query = convert_query(query)
      ds = db[:movies]
        .full_text_search(:content, query, tsvector: true, language: "english")
        .order{ts_rank_cd(content, to_tsquery(query)).desc}
      options.each do |key, action|
        _, operator, value = action.rpartition(/^[<>=]*/)
        operator = "=~" if operator.empty?
        ds = ds.where{__send__(key).send(operator, value)}
      end
      ds = ds.paginate(page, per_page) if per_page
      if highlight
        ds = ds.select{[
          year,
          *[:title, :plot, :episode].map do |column|
            ts_headline(
              __send__(column),
              to_tsquery(query),
              "StartSel = <strong>, StopSel = </strong>, HighlightAll = true"
            ).as(column)
          end
        ]}
      end
      ds.all
    end

    private

    def convert_query(query)
      query = query
        .gsub('AND', '&')
        .gsub('OR', '|')
        .gsub(/(NOT |-)/, '& !')
        .gsub(/(?<=[^&!|]) (?=[^&!|])/, ' & ')
        .gsub(/(?<=\w)\*/, ':*')
    end

    def create_table
      db.create_table :movies do
        primary_key :id

        column :title,   :varchar
        column :year,    :integer
        column :plot,    :text
        column :episode, :varchar

        column :content, :tsvector
      end

      db.run "CREATE EXTENSION unaccent"

      db.run <<-SQL
        CREATE TEXT SEARCH DICTIONARY english_syn (
          TEMPLATE = synonym,
          SYNONYMS = english
        )
      SQL

      db.run <<-SQL
        ALTER TEXT SEARCH CONFIGURATION english
          ALTER MAPPING FOR word, asciiword
          WITH english_syn, unaccent, english_stem
      SQL

      db.run <<-SQL
        CREATE FUNCTION movies_trigger() RETURNS trigger AS $$
        begin
          new.content :=
             setweight(to_tsvector(coalesce(new.title,'')), 'A') ||
             setweight(to_tsvector(coalesce(new.year::text,'')), 'A')  ||
             setweight(to_tsvector(coalesce(new.plot,'')), 'C')  ||
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
      @db ||= (
        db = Sequel.connect("postgres:///diploma")
        db.extension :pagination
      )
    end
  end
end
