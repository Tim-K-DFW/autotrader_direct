require 'pry'

arr = []
item1 = {price: 1500, year: 2004}
item2 = {price: 1800, year: 1990}
item3 = {price: 2500, year: 1800}
arr << item1
arr << item2
arr << item3

p = 'price'
y = 'year'

binding.pry
