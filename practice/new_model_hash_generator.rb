require 'pry'

output = {}

str = File.read('all_models.txt').split(/\r\n/)
str.each do |make|
  this_make = {}
  make_code = /^(.+)&&/.match(make)[1]      # will become key for this make hash
  
  models = make.scan(/<option value=("[^<]+<)\/option>/)   # an array of all models
  models = {}
  models.each do |model|
    this_model = {}           # current model hash
    this_model[:code] = /"([^\\\/]+).+">/.match(model.to_s)[1]
    this_model[:name] = />([^<>]+)</.match(model.to_s)[1]

    models << this_model if (this_model[:name] != 'Any Model' && /Other.+Models/.match(this_model[:name]).nil?)
  # end

  this_make = {make_code, models}
  output.merge!(this_make)
end

binding.pry



# output is array of hashes => make it hash of hashes
#  cannot merge hashes with identical keys
# each make is a hash = GOOD