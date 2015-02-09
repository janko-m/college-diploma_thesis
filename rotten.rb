require "open-uri"
require "pp"
require "json"

json = open("http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=s8myaae5jugnrm9yqytnyydz&page_limit=50&page=3000&q=a").read
pp JSON.parse(json)
