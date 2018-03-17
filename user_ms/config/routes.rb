Rails.application.routes.draw do
  #resources :users
  #devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #resources :sessions, only: [:create, :destroy, :show]
  get '/sessions/:authentication_token', to: 'sessions#show'
  delete '/sessions/:authentication_token', to: 'sessions#destroy'
  post '/sessions', to: 'sessions#create'
end
