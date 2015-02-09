class CreateDocuments < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE VIEW documents AS

        SELECT
          casopis.id AS searchable_id,
          'Casopis' AS searchable_type,
          casopis.tsv AS content
        FROM casopis

        UNION

        SELECT
          disertacija.id AS searchable_id,
          'Disertacija' AS searchable_type,
          disertacija.tsv AS content
        FROM disertacija

        UNION

        SELECT
          knjiga.id AS searchable_id,
          'Knjiga' AS searchable_type,
          knjiga.tsv AS content
        FROM knjiga
    SQL
  end

  def down
    execute "DROP VIEW documents"
  end
end
