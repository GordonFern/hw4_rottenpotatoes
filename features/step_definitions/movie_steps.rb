Given /^the following movies exist:$/ do |movies_table|
  movies_table.hashes.each do |movie|
    the_movie = Movie.create!(movie)
  end
end

 Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1,arg2|
  the_movie=Movie.find_all_by_title(arg1)
  the_movie[0].director = arg2
end


Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  pos1=page.body.index(e1)
  pos1=(pos1==nil) ? 0 : pos1
  pos2=page.body.index(e2)
  pos2=(pos2==nil) ? 0 : pos2
  pos2.should>pos1
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  test_arr=rating_list.split(',')
  test_arr.each do | rating |
    if uncheck == 'un'
      uncheck('ratings_' + rating.strip)
    else
      check('ratings_' + rating.strip)
    end
  end
end

Given /^I submit ratings form$/ do
  click_button('ratings_submit')
end

Then /^I should see (\d+) movies$/ do |arg1|
  no_rows=-1 # Need to exclude header row
  all('#movies tr').each do |td|
    no_rows += 1
  end

  if arg1.strip != no_rows.to_s.strip
    flunk "Expected " + arg1 + " rows - found " + no_rows.to_s
  end
end

Then /I should see only ratings: (.*)/ do | rating_list|
  str_arr=rating_list.gsub(/ /,'').split(',')
  all('#movies tr > td:nth-child(2)').each do |td|
    if !str_arr.include?(td.text)
       flunk "Can't find #{td.text}"
    end
  end
end
