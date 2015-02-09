require "elasticsearch/model"

class Casopis < ActiveRecord::Base
  self.table_name = "casopis"
  self.primary_key = "id"

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(**options)
  end
end

class Knjiga < ActiveRecord::Base
  self.table_name = "knjiga"
  self.primary_key = "id"

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(**options)
  end
end

class Disertacija < ActiveRecord::Base
  self.table_name = "disertacija"
  self.primary_key = "id"

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def as_indexed_json(**options)
  end
end

class Document < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true

  def self.search(query)
    where("content @@ plainto_tsquery('croatian', '#{query}')")
      .order("ts_rank_cd(content, plainto_tsquery('croatian', '#{query}')) DESC")
      .limit(20).preload(:searchable).map(&:searchable)
  end
end
