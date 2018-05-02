Rails.application.routes.draw do
  scope "(:locale)", locale: /ru|en/ do
    resources :parkings do
      resources :parking_places, shallow: true do
        resources :orders, shallow: true
      end
    end
    get 'orders/index'
    get 'control_panel/main'
    get 'control_panel/orders'
    resources :sensors
    devise_for :users
    root 'main#index'
    get 'main/index'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
