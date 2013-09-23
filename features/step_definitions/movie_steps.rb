Given /^the following movies exist:$/ do |movies_table|
  movies_table.hashes.each do |movie|
    the_movie = Movie.create!(movie)
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1,arg2|
  the_movie=Movie.find_all_by_title(arg1)
  the_movie[0].director = arg2
end
