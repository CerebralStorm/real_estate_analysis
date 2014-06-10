RealEstateAnalysis::Application.routes.draw do
  devise_for :users
  resources :listings
  root 'listings#index'
end
