RealEstateAnalysis::Application.routes.draw do
  resources :rental_calculations
  devise_for :users
  resources :listings
  root 'listings#index'
end
