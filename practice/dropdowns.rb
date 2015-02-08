require 'mechanize'
require 'pry'

INITIAL_PAGE = 'http://www.autotrader.com/cars-for-sale/Make/Model/Dallas+TX-75207?endYear=2010&inGalleryView=true&makeCode1=CHEV&mmt=%5BCHEV%5BMALI%5B%5D%5D%5B%5D%5D&modelCode1=MALI&numRecords=100&searchRadius=25&showcaseListingId=390538224&showcaseOwnerId=182528&sortBy=derivedpriceASC&startYear=2007&Log=0'
PAGE_COUNT_HANDLE = '.pageof'
CAR_DIV_HANDLE = '.listing.listing-findcar.gallery.cpo'   # not sure if needed - if it's possible to scrape all by category and they match
TITLE_HANDLE = '.atcui-truncate.ymm'
PRICE_HANDLE = '.atcui-section.atcui-clearfix.price-offer-wrapper'
MILEAGE_HANDLE = '.listing-mileage'       # (\d*,*\d+)\s+miles
LINK_HANDLE = '.vehicle-title.atcui-trigger'
MAKE_HANDLE = '#j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu'
MODEL_HANDLE ="#j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageModel-selectOneMenu"

MAKE = 'Chevrolet'
MODEL = 'Camaro'


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
  # pages = {}
  # (2..page_count).each do |page_num|
  #   str = '&firstRecord=' + ((page_num - 1) * 100 + 1).to_s
  #   pages[page_num] = first_url.gsub('&inGallery', str + '&inGallery')
  # end

  pages = []
  (2..page_count).each do |page_num|
    str = '&firstRecord=' + ((page_num - 1) * 100 + 1).to_s
    pages << first_url.gsub('&inGallery', str + '&inGallery')
  end

  return pages
  binding.pry
end

def scrape_page(page)
  
  results = []
  cars = page.search(CAR_DIV_HANDLE)
  cars.each do |car|
    this_car = {}
    
    mileage_match = /(\d*,*\d+)\s+miles/.match(car.search(MILEAGE_HANDLE).text)    
    if mileage_match
      this_car[:mileage] = mileage_match[1].gsub!(',', '').to_i
    else
      this_car[:mileage] = 'n/a'
    end

    price_match = /\$(\d*,*\d+)/.match(car.search(PRICE_HANDLE).text)
    if price_match
      this_car[:price] = price_match[1].gsub!(',', '').to_i
    else
      this_car[:price] = 'n/a'
    end

    model_match = /\d{4}\s+([a-zA-Z0-9\s]+[a-zA-Z0-9])/.match(car.search(TITLE_HANDLE).text)
    if model_match
      this_car[:model] = model_match[1].gsub!(MAKE + ' ' + MODEL + ' ', '')
    else
      this_car[:model] = 'n/a'
    end
                 
    year_match = /(\d{4})\s+/.match(car.search(TITLE_HANDLE).text)
    if year_match
      this_car[:year] = year_match[1].to_i
    else
      this_car[:year] = 'n/a'
    end

    link_match = car.search(LINK_HANDLE)[0].attributes.first.last.value
    if link_match != '' && !link_match.nil?
      this_car[:link] = 'www.autotrader.com' + link_match
    else
      this_car[:link] = 'n/a'
    end


    results << this_car
  end

  binding.pry
  results
end


# ---------------------------------------------------------------------------------------------------------------

mech = Mechanize.new


start_year = 2006
end_year = 2010
radius = 50
zip = '75024'
url = create_starting_url(make: MAKE, model: MODEL, end_year: end_year, start_year: start_year, radius: radius, zip: zip)

binding.pry

current_page = mech.get(url)
final_results = []
final_results << scrape_page(current_page)     # first page, since it is already loaded

 
# each page will return array of hashes (one hash per car)
# each page result (i.e. array) will be appended to final output array
# after all pages appended, final array fill be flattened

count = page_count(current_page)

if count > 1
  page_links = all_page_urls(url, count)
  binding.pry

  page_links.each do |link|
    current_page = mech.get(link)
    final_results << scrape_page(current_page)
  end
end

final_results.flatten!

binding.pry