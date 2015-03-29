Given(/^I'm using (\w+)$/) do |engine|
  @engine = Engine.const_get(engine.capitalize).new
end

Given(/^I have movies$/) do |table|
  movies = table.hashes
  @engine.clear
  @engine.import(movies)
end

When(/^I enter a search query "(.+)"$/) do |query|
  @results = @engine.search(query)
end

When(/^I enter a search query "(.+)" with options "(.+)"$/) do |query, params|
  @results = @engine.search(query, eval(params))
end

Then(/^the first result should be "(.+)"$/) do |title|
  expect(@results.first[:title]).to eq title
end

Then(/^I should get results "(.+)"$/) do |array|
  expect(@results.map { |h| h[:title] }).to eq eval(array)
end

Then(/^the results should be empty$/) do
  expect(@results).to be_empty
end
