RealEstateAnalysis::Application.routes.draw do
  get 'pages/index'

  resources :zip_codes do
    get :toggle, on: :member
  end
  resources :rental_calculations
  devise_for :users
  resources :listings do
    get :toggle, on: :member
    get :favorite, on: :member
    get :toggle_boolean, on: :member
  end
  root 'listings#index'
end
