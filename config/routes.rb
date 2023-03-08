Rails.application.routes.draw do
  resources :locations do
    collection do
      post 'search'
    end
  end
  get 'static_pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "static_pages#home"
end
