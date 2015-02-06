require "json"

Given(/^I have papers$/) do |table|
  Paper.create(table.hashes)
end

When(/^I search (\w+) for "(.+)"$/) do |engine, query|
  get "/", q: query, engine: engine
end

Then(/^I should get back papers$/) do |table|
  papers = JSON.parse(last_response.body)
  paper_titles = papers.map { |paper| paper["title"] }

  assert_equal table.raw.flatten, paper_titles
end

Then(/^I should get back no papers$/) do
  papers = JSON.parse(last_response.body)

  assert_empty papers
end
