Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
    
    registrations: 'users/registrations'
  }
  
  resources :books
  resources :users, only: [:show, :edit, :index, :update]
  
  root to: 'homes#top'
  get "/home/about" => "homes#about", as: "about"
  
end
