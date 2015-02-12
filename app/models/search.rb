class Search
  require 'csv'
  include ActiveModel::Model
  
  attr_accessor :valid, :zip, :make, :model, :beginning_year, :ending_year, :radius, :results, :sort_order, :sort_direction, :makes_list
  
  validates :make, :zip, :beginning_year, :ending_year, presence: true
  validate :years_sequence

  INITIAL_PAGE = 'http://www.autotrader.com/cars-for-sale/Make/Dallas+TX-75207?endYear=2010&inGalleryView=true&numRecords=100&searchRadius=25&sortBy=derivedpriceASC&startYear=2007&Log=0'
  PAGE_COUNT_HANDLE = '.pageof'
  CAR_DIV_HANDLE = '.listing.listing-findcar.gallery.cpo'
  TITLE_HANDLE = '.atcui-truncate.ymm'
  PRICE_HANDLE = '.atcui-section.atcui-clearfix.price-offer-wrapper'
  MILEAGE_HANDLE = '.listing-mileage'
  LINK_HANDLE = '.vehicle-title.atcui-trigger'
  MAKE_HANDLE = '#j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu'

  
  def initialize(params = nil)
    Search::INITIAL_PAGE
    if params
      @zip = params[:zip]
      @make = params[:make]
      @model = params[:model]
      @beginning_year = params[:beginning_year]
      @ending_year = params[:ending_year]
      @radius = params[:radius]
      @sort_order = 'price'
      @sort_direction = 'asc'
    end
    @makes_list = makes_list
  end

  def years_sequence
    if !self.nil? && self.ending_year.to_i < self.beginning_year.to_i
      self.errors.add(:beginning_year, 'cannot be greater that ending year')
    end
  end

  def perform_search
    mech = Mechanize.new
    url = create_starting_url
    current_page = mech.get(url)
    final_results = []
    final_results << scrape_page(current_page)     # first page, since it is already loaded
    count = page_count(current_page)

    if count > 1
      page_links = all_page_urls(url, count)
      
      page_links.each do |link|
        current_page = mech.get(link)
        final_results << scrape_page(current_page)
      end
    end
    final_results.flatten!
    self.results = final_results
 end

  def sort
    self.sort_direction = self.sort_direction == 'asc' ? 'desc' : 'asc'         # invert
    if self.sort_direction == 'asc'
      if self.sort_order == 'model'
        self.results.sort_by! {|car| car[:model] }.reverse!                           # model has to be sorted as a string
      else
        self.results.sort_by! {|car| car[self.sort_order.to_sym].to_i }.reverse!      # year, mileage and price sorted numerically
      end
    else
      if self.sort_order == 'model'
        self.results.sort_by! {|car| car[:model] }
      else
        self.results.sort_by! {|car| car[self.sort_order.to_sym].to_i }
      end
    end
  end

  # private

  def makes_list
    CSV.read('app/helpers/makes.csv')
  end

  def models_list(make)
    full_list = []
    str = File.read('app/helpers/all_models.txt').split(/\r\n/)
    str.each do |make|
      this_make = {}
      this_make[:code] = /^(.+)&&/.match(make)[1]
      models = make.scan(/<option value=("[^<]+<)\/option>/)
      this_make[:models] = []
      models.each do |model|
        this_model = {}
        this_model[:code] = /"([^\\\/]+).+">/.match(model.to_s)[1]
        this_model[:name] = />([^<>]+)</.match(model.to_s)[1]
        if /\(\d+\)$/.match(this_model[:name])
          this_model[:is_series] = true
        else
          this_model[:is_series] = false
        end
        this_make[:models] << this_model if (this_model[:name] != 'Any Model' && /Other.+Models/.match(this_model[:name]).nil?)
      end
      full_list << this_make
    end

    select_html = [['--Any model', 'ANY']]
    models_hash = full_list.select{|m| m[:code] == make}.first[:models]
    models_hash.each do |model|
      this_model = []
      this_model << model[:name]
      this_model << model[:code]
      select_html << this_model
    end
    return select_html
  end

  def create_starting_url
    self.make.gsub!(' ', '+')
    url = Search::INITIAL_PAGE.dup    # for some reason, with simple assginment gsub! tried to mutate the constant
    url.gsub!('/Make/', '/' + self.make + '/')
    url.gsub!('endYear=2010', 'endYear=' + self.ending_year)
    url.gsub!('startYear=2007', 'startYear=' + self.beginning_year)
    url.gsub!('Radius=25', 'Radius=' + self.radius)
    url.gsub!('75207', self.zip)
    url.gsub!('=100&search', "=100&mmt=#{mmt(self.make, self.model)}&search")
    return url
  end

  def mmt(make, model)
    models = models_list(make)
    model_name = models.select{|m| m[1] == model}.first[0]
    if /Any model/.match(model_name)                  
      mmt="%5B#{make}%5B%5D%5B%5D%5D"                  # any model of this make
    elsif /\(\d+\)$/.match(model_name)
      mmt = "%5B#{make}%5B%5D%5B#{model}%5B%5D%5D%5D"  # series
    else
      mmt = "%5B#{make}%5B#{model}%5B%5D%5D%5B%5D%5D"  # specific model
    end
    return mmt
  end

  def page_count(page)
    str = page.at(PAGE_COUNT_HANDLE).text
    result = /of\s+(\d+)/.match(str)[1].to_i
    return result
  end

  def all_page_urls(first_url, page_count)
    pages = []
    (2..page_count).each do |page_num|
      str = '&firstRecord=' + ((page_num - 1) * 100 + 1).to_s
      pages << first_url.gsub('&inGallery', str + '&inGallery')
    end

    return pages
  end

  def scrape_page(page)
    this_page = []
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

      model_match = /\d{4}\s+([a-zA-Z0-9\-\s\&;]+[a-zA-Z0-9])/.match(car.search(TITLE_HANDLE).text)
      if model_match
        # this_car[:model] = model_match[1].gsub!(self.make + ' ' + self.model + ' ', '')
        this_car[:model] = model_match[1]
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
        this_car[:link] = 'http://www.autotrader.com' + link_match
      else
        this_car[:link] = 'n/a'
      end

      this_page << this_car
    end
    
    return this_page
  end
   
 end