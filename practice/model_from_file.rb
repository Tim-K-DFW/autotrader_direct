require 'pry'

output = []

str = File.read('all_models.txt').split(/\r\n/)
str.each do |make|
  this_make = {}
  this_make[:code] = /^(.+)&&/.match(make)[1]
  models = make.scan(/<option value=("[^<]+<)\/option>/)
  this_make[:models] = []
  models.each do |model|
    this_model = {}
    this_model[:code] = /"([^\\\/]+).+">/.match(model.to_s)[1]
    this_model[:name] = />([^<>]+)</.match(model.to_s)[1]
    this_make[:models] << this_model if (this_model[:name] != 'Any Model' && /Other.+Models/.match(this_model[:name]).nil?)
  end
  output << this_make
end

binding.pry