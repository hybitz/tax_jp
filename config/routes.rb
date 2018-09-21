TaxJp::Engine.routes.draw do
  resources :depreciation_rates, only: 'index'
  resources :employment_insurances, only: 'index'

  root to: 'top#index'
end
