Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/" => "home#top"
  get "/about" => "home#about"

  get "/login" => "users#login_form"
  post "/login" => "users#login"
  post "/logout" => "users#logout"

  get "/users/index" => "users#index"
  get "/users/signup" => "users#new"
  post "/users/create" => "users#create"

  get "/users/:id" => "users#show"
  get "/users/:id/edit" => "users#edit"
  post "/users/:id/update" => "users#update"
  get "/users/:id/board_edit" => "users#board_edit"
  post "/users/:id/board_update" => "users#board_update"



end
