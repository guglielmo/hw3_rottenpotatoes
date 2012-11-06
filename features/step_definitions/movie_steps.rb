# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies|
  @rows = movies.hashes.length
  movies.hashes.each do |movie|
      Movie.create!(movie)
  end
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.body.index(e1) < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(',').each do |rating|
    rating_id = "ratings_#{rating.strip}"
    if uncheck
      steps %Q{When I uncheck "#{rating_id}"}
    else
      steps %Q{When I check "#{rating_id}"}
    end
  end

end


When /I (un)?check all the ratings/ do |uncheck|
  if uncheck
    steps "When I uncheck the following ratings: #{Movie.all_ratings.join(", ")}"
  else
    steps "When I check the following ratings: #{Movie.all_ratings.join(", ")}"
  end
end


Then /I should( not)? see the following movies/ do |notsee, movies|
  movies.hashes.each do |movie|
    if notsee
      steps %Q{Then I should not see "#{movie[:title]}"}
    else
      steps %Q{Then I should see "#{movie[:title]}"}
    end
  end
end

Then /I should see all the (.*) movies/ do |n_movies|
  page.has_css?("div.records li", :count => Integer(n_movies), :msg =>"I count #{n_movies}")
end