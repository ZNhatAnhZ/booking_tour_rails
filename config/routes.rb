Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users, only: %i(new create)
    resources :tours, only: %i(index show)
    resources :tour_requests, except: %i(new show edit)
    resources :reviews, only: :create
    namespace :admin do
      resources :users, only: %i(index edit update destroy)
      get "/tours/filter", to: "tours#filter_tour"
      resources :tours
      resources :reviews
      resources :tour_requests
      resources :filter_tours, only: %i(index)
    end
    get "/authorization/:id", to: "authorizations#edit", as: :authorization
    post "/authorization/:id", to: "authorizations#update",
                               as: :authorization_activate
    mount ActionCable.server => "/cable"
  end
end
