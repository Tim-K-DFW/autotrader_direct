module ApplicationHelper
  require 'csv'

  def makes_list
    CSV.read('app/helpers/makes.csv')
  end

end