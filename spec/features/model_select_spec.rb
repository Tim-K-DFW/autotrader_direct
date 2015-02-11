require 'spec_helper'

feature 'make selection produces model selection' do
  scenario 'user clicks a model' do
    visit '/new'
    select 'Acura', from: 'Make'
    expect(find('#search_model')).to have_content('Integra')
  end
end