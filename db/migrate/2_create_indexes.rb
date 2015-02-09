class CreateIndexes < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute "DROP INDEX IF EXISTS casopis_idx"
        execute "DROP INDEX IF EXISTS casopis_autori_idx"
        execute "DROP INDEX IF EXISTS casopis_cc_idx"
        execute "DROP INDEX IF EXISTS casopis_fti_au_idx"
        execute "DROP INDEX IF EXISTS casopis_fti_os_idx"
        execute "DROP INDEX IF EXISTS casopis_fti_pr_idx"
        execute "DROP INDEX IF EXISTS casopis_godina_idx"
        execute "DROP INDEX IF EXISTS casopis_issn_idx"
        execute "DROP INDEX IF EXISTS casopis_kategorija_idx"
        execute "DROP INDEX IF EXISTS casopis_key_words_idx"
        execute "DROP INDEX IF EXISTS casopis_kljucne_rijeci_idx"
        execute "DROP INDEX IF EXISTS casopis_naslov_idx"
        execute "DROP INDEX IF EXISTS casopis_nn_idx"
        execute "DROP INDEX IF EXISTS casopis_sc_idx"
        execute "DROP INDEX IF EXISTS casopis_title_idx"

        execute "DROP TRIGGER IF EXISTS fti_au_update ON casopis"
        execute "DROP TRIGGER IF EXISTS fti_os_update ON casopis"
        execute "DROP TRIGGER IF EXISTS fti_pr_update ON casopis"

        execute "DROP INDEX IF EXISTS disertacija_idx"
        execute "DROP INDEX IF EXISTS disertacija_autori_idx"
        execute "DROP INDEX IF EXISTS disertacija_datum_idx"
        execute "DROP INDEX IF EXISTS disertacija_fti_au_idx"
        execute "DROP INDEX IF EXISTS disertacija_fti_os_idx"
        execute "DROP INDEX IF EXISTS disertacija_fti_pr_idx"
        execute "DROP INDEX IF EXISTS disertacija_godina_idx"
        execute "DROP INDEX IF EXISTS disertacija_key_words_idx"
        execute "DROP INDEX IF EXISTS disertacija_kljucne_rijeci_idx"
        execute "DROP INDEX IF EXISTS disertacija_naslov_idx"
        execute "DROP INDEX IF EXISTS disertacija_title_idx"
        execute "DROP INDEX IF EXISTS disertacija_vrsta_idx"

        execute "DROP TRIGGER IF EXISTS fti_au_update ON disertacija"
        execute "DROP TRIGGER IF EXISTS fti_os_update ON disertacija"
        execute "DROP TRIGGER IF EXISTS fti_pr_update ON disertacija"

        execute "DROP INDEX IF EXISTS knjiga_idx"
        execute "DROP INDEX IF EXISTS knjiga_autori_idx"
        execute "DROP INDEX IF EXISTS knjiga_fti_au_idx"
        execute "DROP INDEX IF EXISTS knjiga_fti_os_idx"
        execute "DROP INDEX IF EXISTS knjiga_fti_pr_idx"
        execute "DROP INDEX IF EXISTS knjiga_godina_idx"
        execute "DROP INDEX IF EXISTS knjiga_isbn_idx"
        execute "DROP INDEX IF EXISTS knjiga_key_words_idx"
        execute "DROP INDEX IF EXISTS knjiga_kljucne_rijeci_idx"
        execute "DROP INDEX IF EXISTS knjiga_naslov_idx"
        execute "DROP INDEX IF EXISTS knjiga_title_idx"
        execute "DROP INDEX IF EXISTS knjiga_urednik_idx"

        execute "DROP TRIGGER IF EXISTS fti_au_update ON knjiga"
        execute "DROP TRIGGER IF EXISTS fti_os_update ON knjiga"
        execute "DROP TRIGGER IF EXISTS fti_pr_update ON knjiga"
      end
    end

    remove_column :casopis, :fti_au, :tsvector
    remove_column :casopis, :fti_pr, :tsvector
    remove_column :casopis, :fti_os, :tsvector
    add_column :casopis, :tsv, :tsvector

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE casopis
          SET tsv =
            setweight(to_tsvector('croatian', coalesce(naslov, '')),         'A') ||
            setweight(to_tsvector('croatian', coalesce(title, '')),          'A') ||
            setweight(to_tsvector('croatian', coalesce(autori, '')),         'B') ||
            setweight(to_tsvector('croatian', coalesce(kljucne_rijeci, '')), 'B') ||
            setweight(to_tsvector('croatian', coalesce(key_words, '')),      'B') ||
            setweight(to_tsvector('croatian', coalesce(sazetak, '')),        'C')
        SQL
      end
      dir.down {}
    end

    remove_column :disertacija, :fti_au, :tsvector
    remove_column :disertacija, :fti_pr, :tsvector
    remove_column :disertacija, :fti_os, :tsvector
    add_column :disertacija, :tsv, :tsvector

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE disertacija
          SET tsv =
            setweight(to_tsvector('croatian', coalesce(naslov, '')),              'A') ||
            setweight(to_tsvector('croatian', coalesce(title, '')),               'A') ||
            setweight(to_tsvector('croatian', coalesce(autori, '')),              'B') ||
            setweight(to_tsvector('croatian', coalesce(kljucne_rijeci, '')),      'B') ||
            setweight(to_tsvector('croatian', coalesce(key_words, '')),           'B') ||
            setweight(to_tsvector('croatian', coalesce(sazetak, '')),             'C') ||
            setweight(to_tsvector('croatian', coalesce(mentor, '')),              'C') ||
            setweight(to_tsvector('croatian', coalesce(neposredni_voditelj, '')), 'C')
        SQL
      end
      dir.down {}
    end

    remove_column :knjiga, :fti_au, :tsvector
    remove_column :knjiga, :fti_pr, :tsvector
    remove_column :knjiga, :fti_os, :tsvector
    add_column :knjiga, :tsv, :tsvector

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE knjiga
          SET tsv =
            setweight(to_tsvector('croatian', coalesce(naslov, '')),           'A') ||
            setweight(to_tsvector('croatian', coalesce(title, '')),            'A') ||
            setweight(to_tsvector('croatian', coalesce(autori, '')),           'B') ||
            setweight(to_tsvector('croatian', coalesce(kljucne_rijeci, '')),   'B') ||
            setweight(to_tsvector('croatian', coalesce(key_words, '')),        'B') ||
            setweight(to_tsvector('croatian', coalesce(sazetak, '')),          'C') ||
            setweight(to_tsvector('croatian', coalesce(urednik, '')),          'C') ||
            setweight(to_tsvector('croatian', coalesce(prevodilac, '')),       'C') ||
            setweight(to_tsvector('croatian', coalesce(formalni_urednik, '')), 'C')
        SQL
      end
      dir.down {}
    end

    reversible do |direction|
      direction.up   { execute "CREATE INDEX casopis_idx ON casopis USING gin(tsv)" }
      direction.down { execute "DROP INDEX casopis_idx" }
    end

    reversible do |direction|
      direction.up   { execute "CREATE INDEX disertacija_idx ON disertacija USING gin(tsv)" }
      direction.down { execute "DROP INDEX disertacija_idx" }
    end

    reversible do |direction|
      direction.up   { execute "CREATE INDEX knjiga_idx ON knjiga USING gin(tsv)" }
      direction.down { execute "DROP INDEX knjiga_idx" }
    end
  end
end
