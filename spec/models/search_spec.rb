require 'spec_helper'

describe Search do
  describe '.create_starting_url' do
    it 'creates correct mmt string with regular model' do
      make = 'HONDA'
      model = 'ACCORD'
      s = Search.new(make: make, model: model, zip: '31404', beginning_year: '2010', ending_year: '2013', radius: '25')
      url = s.create_starting_url
      expect(url).to include('%5BHONDA%5BACCORD%5B%5D%5D%5B%5D%5D')
    end

    it 'creates correct mmt string with series' do
      make = 'MB'
      model = 'C_CLASS'
      s = Search.new(make: make, model: model, zip: '31404', beginning_year: '2010', ending_year: '2013', radius: '25')
      url = s.create_starting_url
      expect(url).to include('%5BMB%5B%5D%5BC_CLASS%5B%5D%5D%5D')
    end
    
    it 'adds make to the url'
  end
end