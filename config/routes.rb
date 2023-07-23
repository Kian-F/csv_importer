Rails.application.routes.draw do
  get 'people/index'
  resource :import, only: [:new, :create]
  match 'people', to: 'people#cors_preflight_check', via: [:options]
  resources :people
  resources :people, only: [:index, :create]
end

