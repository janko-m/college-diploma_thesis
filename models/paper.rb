require "pg_search"

class Paper < ActiveRecord::Base
  include PgSearch

  belongs_to :author, class_name: "Member"
  belongs_to :mentor, class_name: "Member"

  scope :popular, -> { all }

  pg_search_scope :search,
    against: [:title, :summary],
    associated_against: {
      author: [:first_name, :last_name],
      mentor: [:first_name, :last_name],
    },
    using: {
      tsearch: {dictionary: "croatian"},
      trigram: {threshold: 0.8},
    }
    # http://stackoverflow.com/questions/11005036/does-postgresql-support-accent-insensitive-collations
    # ignoring: :accents
end
