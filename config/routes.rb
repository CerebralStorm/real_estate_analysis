RealEstateAnalysis::Application.routes.draw do
  resources :zip_codes
  resources :rental_calculations
  devise_for :users
  resources :listings do
    get :toggle, on: :member
  end
  root 'listings#index'
end
