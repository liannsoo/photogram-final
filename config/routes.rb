Rails.application.routes.draw do
  devise_for :users

  root "users#index"

  # Resource routes for FollowRequests
  post '/follow_requests/follow', to: 'follow_requests#create', as: :follow_follow_requests
  delete '/follow_requests/unfollow/:id', to: 'follow_requests#destroy', as: :unfollow_follow_requests
  delete '/follow_requests/cancel/:id', to: 'follow_requests#cancel', as: :cancel_request_follow_requests

  # Add routes for accepting and rejecting follow requests
  patch '/follow_requests/:id/accept', to: 'follow_requests#accept', as: :accept_follow_request
  delete '/follow_requests/:id/reject', to: 'follow_requests#reject', as: :reject_follow_request

  # Routes for the Photo resource with nested routes for comments
  resources :photos, only: [:index, :show, :create, :update, :destroy] do
    member do
      post :like
      delete :unlike
    end
  end

  # Resource routes for Users
  resources :users, only: [:index, :show] do
    member do
      get 'liked_photos', to: 'photos#liked_photos'
      get 'feed', to: 'photos#feed'
      get 'discover', to: 'photos#discover'
    end
  end

  # Resource routes for Likes
  resources :likes, except: [:new, :edit] # Assuming new and edit are not used
end
