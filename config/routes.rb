RealEstateAnalysis::Application.routes.draw do
  resources :contacts
  root 'listings#index'

  resources :zip_codes do
    get :toggle, on: :member
  end
  resources :rental_calculations do
    get :calculator, on: :collection
  end

  # devise_for :users
  resources :listings do
    get :toggle, on: :member
    get :favorite, on: :member
    get :toggle_boolean, on: :member
  end
end
