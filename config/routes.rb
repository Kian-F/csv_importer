Rails.application.routes.draw do
  get 'people/index'
  resource :import, only: [:new, :create]
  resources :people, only: [:index]
end

