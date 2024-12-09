Rails.application.routes.draw do
  devise_for :users

  root "users#index"

  # Resource routes for FollowRequests
  post '/follow_requests/follow', to: 'follow_requests#create', as: :follow_follow_requests
  delete '/follow_requests/unfollow/:id', to: 'follow_requests#destroy', as: :unfollow_follow_requests
  delete '/follow_requests/cancel/:id', to: 'follow_requests#cancel', as: :cancel_request_follow_requests
  patch '/follow_requests/:id/accept', to: 'follow_requests#accept', as: :accept_follow_request
  delete '/follow_requests/:id/reject', to: 'follow_requests#reject', as: :reject_follow_request

  # Routes for the Photo resource with nested routes for comments
  resources :photos, only: [:index, :show, :create, :update, :edit, :destroy] do
    member do
      post :like
      delete :unlike
    end
    resources :comments, only: [:create, :destroy]
  end

  # Resource routes for Users
  resources :users, only: [:index, :show] do
    member do
      post 'follow', to: 'follow_requests#create'
      delete 'unfollow', to: 'follow_requests#destroy'
      delete 'cancel_follow', to: 'follow_requests#cancel'
      get 'feed', to: 'users#show', defaults: { show_section: 'feed' }
      get 'liked_photos', to: 'users#show', defaults: { show_section: 'liked_photos' }
      get 'discover', to: 'users#show', defaults: { show_section: 'discover' }
      get 'own', to: 'users#show', defaults: { show_section: 'own' }
    end
  end

  # Resource routes for Likes
  resources :likes, except: [:new, :edit] # Assuming new and edit are not used
end
