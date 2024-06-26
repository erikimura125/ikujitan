Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:destroy]
  end

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "homes#top"

  resources :posts, only: [:new, :create, :index, :show, :destroy, :edit, :update] do
    resource :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  resources :users, only: [:show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
  end
  
  resources :users do
    member do
      get :likes
    end
  end

  resources :messages, only: [:create]

  resources :rooms, only: [:create, :show, :index]

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  get '/search', to: 'searches#search'

  get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
  patch '/users/:id/withdraw' => 'users#withdraw', as: 'withdraw'

  resources :notifications, only: [:index]

 # get 'posts/life', to: 'posts#life', as: 'life_posts'
  #get 'posts/cook', to: 'posts#cook', as: 'cook_posts'
  #get 'posts/toy', to: 'posts#toy', as: 'toy_posts'

end