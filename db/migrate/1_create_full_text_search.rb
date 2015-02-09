class CreateFullTextSearch < ActiveRecord::Migration
  def change
    enable_extension "pg_trgm"
    enable_extension "unaccent"

    reversible do |direction|
      direction.up do
        execute <<-SQL
          CREATE TEXT SEARCH DICTIONARY croatian (
            Template = ispell,
            DictFile = croatian,
            StopWords = croatian,
            AffFile = croatian
          );
        SQL
      end
      direction.down { execute "DROP TEXT SEARCH DICTIONARY croatian" }
    end

    reversible do |direction|
      direction.up do
        execute <<-SQL
          CREATE TEXT SEARCH CONFIGURATION croatian (COPY = english);
          ALTER TEXT SEARCH CONFIGURATION croatian
            ALTER MAPPING FOR asciiword, word, asciihword, hword, hword_part, hword_asciipart
            WITH croatian, simple;
        SQL
      end
      direction.down { execute "DROP TEXT SEARCH CONFIGURATION croatian" }
    end
  end
end
