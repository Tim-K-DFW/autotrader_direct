require 'pry'
require 'csv'

def get_make_list
  CSV.read('makes.csv')
end

def get_model_hash
  output = []
  str = File.read('all_models.txt').split(/\r\n/)
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
    output << this_make
  end
  return output
end
 
# ============================================================================

make_list = get_make_list
models_list = get_model_hash
binding.pry