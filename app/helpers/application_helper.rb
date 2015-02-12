module ApplicationHelper
  require 'csv'

  def makes_list
    CSV.read('app/helpers/makes.csv')
  end

  def models_list(make)
    full_list = []
    str = File.read('app/helpers/all_models.txt').split(/\r\n/)
    str.each do |make|
      this_make = {}
      this_make[:code] = /^(.+)&&/.match(make)[1]
      # this_make[:name] = make_list[this_make[:code]]
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

    select_html = []
    models_hash = full_list.select{|m| m[:code] == make}.first[:models]
    models_hash.each do |model|
      this_model = []
      this_model << model[:name]
      this_model << model[:code]
      select_html << this_model
    end
    return select_html
  end

end