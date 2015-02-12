require 'spec_helper'

describe MainController do
  describe 'POST models' do
    it 'renders select with appropriate models' do
      xhr :post, :models, make: 'ACURA'
      binding.pry
      # expect(response).to include('Integra')
    end

  end
end