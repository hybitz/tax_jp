TaxJp::Engine.routes.draw do
  resources :depreciation_rates, only: 'index'

  root to: 'top#index'
end
