require "sinatra/base"
require "sinatra/activerecord"

require_relative "models/paper"
require_relative "models/member"

class ScientificBibliography < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get "/" do
    if params[:q]
      Paper.search(params[:q]).to_json
    else
      Paper.popular.to_json
    end
  end
end
