require 'mechanize'
require 'pry'

MAKE_HANDLE = '#j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu'

mech = Mechanize.new
page = mech.get('http://www.autotrader.com')
list = []
3.step(page.search(MAKE_HANDLE).children.size-1, 2) do |i|
  this_entry = page.search(MAKE_HANDLE).children[i]         # next section of source makes list
  this_element = []                                         # next element of output array
  this_element << this_entry.children.text                  # text to display
  this_element << this_entry.attributes["value"].value      # value to submit
  list << this_element
end
makes_list = list

binding.pry