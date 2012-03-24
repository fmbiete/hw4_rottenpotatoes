# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  e1_location = page.body.index(e1)
  e2_location = page.body.index(e2)
  assert !e1_location.nil?, "#{e1} not found"
  assert !e2_location.nil?, "#{e2} not found"
  assert e1_location < e2_location, "#{e1} does not appear before #{e2}"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(", ").each do |rating|
    rating_id = "ratings_#{rating}"
    uncheck ? uncheck(rating_id) : check(rating_id)
  end
end

Then /^I should see (all|none) of the movies$/ do |display|
  movie_table = page.find('#movies')
  row_count = movie_table.all('tr').length
  expected_rows = display == 'all'? 11 : 1
  assert row_count == expected_rows, "Expected #{expected_rows - 1} Movies, Got #{row_count - 1}"
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movieTitle, director|
  movieTitle.in?(Movie.where(:director => director).select(:title))
end
