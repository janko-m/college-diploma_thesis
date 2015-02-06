class Member < ActiveRecord::Base
  has_many :papers, foreign_key: :author_id

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, :last_name
end
