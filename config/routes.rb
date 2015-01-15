PostitTemplate::Application.routes.draw do
  root to: 'main#index'
  get '/new', to: 'main#new'
  post '/new', to: 'main#submit'
  get '/output', to: 'main#results'
end
