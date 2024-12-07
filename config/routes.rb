Rails.application.routes.draw do
  devise_for :users

  root "users#index"

  # Resource routes for FollowRequests
  post '/follow_requests/follow', to: 'follow_requests#create', as: :follow_follow_requests
  delete '/follow_requests/unfollow/:id', to: 'follow_requests#destroy', as: :unfollow_follow_requests
  delete '/follow_requests/cancel/:id', to: 'follow_requests#cancel', as: :cancel_request_follow_requests


  # Routes for the Photo resource with nested routes for comments
  resources :photos do
    resources :comments, only: [:create, :destroy]
    get 'my_likes', on: :collection
    get 'my_timeline', on: :collection
  end

  # Resource routes for Users
  resources :users, only: [:index, :show]

  # Resource routes for Likes
  resources :likes, except: [:new, :edit] # Assuming new and edit are not used

  # Resource routes for Comments
  resources :comments, except: [:new, :edit] # Assuming new and edit are not used

end
