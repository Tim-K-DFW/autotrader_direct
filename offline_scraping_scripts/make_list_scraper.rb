require 'mechanize'
require 'pry'
require 'csv'

MAKE_HANDLE = '#j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu'

mech = Mechanize.new
page = mech.get('http://www.autotrader.com')

list = {}
3.step(page.search(MAKE_HANDLE).children.size-1, 2) do |i|
  this_entry = page.search(MAKE_HANDLE).children[i]         # next section of source makes list
  make_screen_name = this_entry.children.text                  # text to display
  make_code = this_entry.attributes["value"].value      # value to submit
  this_make = {}
  this_make[make_code] = make_screen_name
  list.merge!(this_make)
end

output = File.open('all_makes.txt', 'w+')
  list.each {|make| output << make}
output.close

CSV.open("makes.csv", "w+") do |csv|
  list.each {|make| csv << [make[1], make[0]]}
end

binding.pry