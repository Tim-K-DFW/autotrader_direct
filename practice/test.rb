require 'mechanize'
require 'pry'

INITIAL_PAGE = 'http://www.autotrader.com/cars-for-sale/Make/Model/Dallas+TX-75207?endYear=2010&inGalleryView=true&makeCode1=CHEV&mmt=%5BCHEV%5BMALI%5B%5D%5D%5B%5D%5D&modelCode1=MALI&numRecords=100&searchRadius=25&showcaseListingId=390538224&showcaseOwnerId=182528&sortBy=derivedpriceASC&startYear=2007&Log=0'
PAGE_COUNT_HANDLE = '.pageof'
CAR_DIV_HANDLE = '.listing listing-findcar gallery cpo  '   # not sure if needed - if it's possible to scrape all by category and they match
TITLE_HANDLE = '.atcui-section atcui-clearfix   listing-title '
PRICE_HANDLE = '.atcui-section atcui-clearfix   price-offer-wrapper '
MILEAGE_HANDLE = '.listing-mileage'       # (\d*,*\d+)\s+miles



def create_starting_url(params)
  url = INITIAL_PAGE
  url.gsub!('/Make/', '/' + params[:make] + '/')
  url.gsub!('/Model/', '/' + params[:model] + '/')
  url.gsub!('endYear=2010', 'endYear=' + params[:end_year].to_s)
  url.gsub!('startYear=2007', 'startYear=' + params[:start_year].to_s)
  url.gsub!('Radius=25', 'Radius=' + params[:radius].to_s)
  url.gsub!('75207', params[:zip])

end


def page_count(page)
  str = page.at(PAGE_COUNT_HANDLE).text
  result = /of\s+(\d+)/.match(str)[1].to_i
end

def all_page_urls(first_url, page_count)
  pages = {}
  (2..page_count).each do |page_num|
    str = '&firstRecord=' + ((page_num - 1) * 100 + 1).to_s
    pages[page_num] = first_url.gsub('&inGallery', str + '&inGallery')
  end
  binding.pry
end

def scrape(page)  #  returns hash of car info 
  # id "scope" for every car (100 per page)
  # iterate through all scopes
  # scrape price, year, model and link
  results = {}
  results[:mileages] = []
  page.search(MILEAGE_HANDLE).each {|entry| results[:mileages] << /(\d*,*\d+)\s+miles/.match(entry.children.text)[1].gsub!(',','').to_i}
  binding.pry
end


# ---------------------------------------------------------------------------------------------------------------

mech = Mechanize.new

make = 'Chevrolet'
model = 'Camaro'
start_year = 2008
end_year = 2012
radius = 50
zip = '31404'
url = create_starting_url(make: make, model: model, end_year: end_year, start_year: start_year, radius: radius, zip: zip)
current_page = mech.get(url)
count = page_count(current_page)
page_links = all_page_urls(url, count) if count > 1

# each page will return array of hashes (one hash per car)
# each page result (i.e. array) will be appended to final output array
# after all pages appended, final array fill be flattened

results = []
results << scrape(current_page)     # first page, since it is already loaded

if count > 1
  page_links.each do |link|
    current_page = mech.get(link)
    results << scrape(current_page)
  end
end