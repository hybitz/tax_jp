TaxJp::Engine.routes.draw do
  resources :bonus_withheld_taxes, only: 'index'
  resources :depreciation_rates, only: 'index'
  resources :employment_insurances, only: 'index'
  resources :social_insurances, only: 'index'
  resources :withheld_taxes, only: 'index'

  root to: 'top#index'
end
