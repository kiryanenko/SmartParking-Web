Rails.application.routes.draw do
  scope "(:locale)", locale: /ru|en/ do
    resources :parkings do
      resources :parking_places, shallow: true
    end
    get 'control_panel/main'
    resources :sensors
    devise_for :users
    root 'main#index'
    get 'main/index'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
