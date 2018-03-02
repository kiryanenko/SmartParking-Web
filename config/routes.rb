Rails.application.routes.draw do
  resources :parkings
  get 'control_panel/main'
  resources :sensors
  devise_for :users
  root 'main#index'
  get 'main/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
