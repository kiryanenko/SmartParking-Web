Rails.application.routes.draw do
  scope "(:locale)", locale: /ru|en/ do
    resources :parking_places
    resources :parkings
    get 'control_panel/main'
    resources :sensors
    devise_for :users
    root 'main#index'
    get 'main/index'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
