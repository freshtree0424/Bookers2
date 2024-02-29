Rails.application.routes.draw do

  devise_for :users

  root to: "homes#top"
  get '/home/about' => 'homes#about', as:'about'

  resources :books, only: [:create, :index, :show, :edit, :update ,:destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  
  resources :users, only: [:show, :edit, :update, :index]
  post 'follow/:id' => 'relationships#follow', as: 'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  
  get "search" => "searches#search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
