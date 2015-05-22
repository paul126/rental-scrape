Rails.application.routes.draw do

  root to: 'static_pages#root'

  get '/zillow', to: 'static_pages#zillow'
  get '/corcoran', to: 'static_pages#corcoran'

  resources :listings, only: [:index, :show]
  resources :saved_listings, only: [:index]


end
