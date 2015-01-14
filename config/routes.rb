PostitTemplate::Application.routes.draw do
  root to: 'reports#index'
  get '/new', to: 'reports#new'
  post '/new', to: 'reports#create'
  get '/output', to: 'reports#output'
end
