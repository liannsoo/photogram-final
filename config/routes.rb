Rails.application.routes.draw do
  
  devise_for :users

  root "photos#index"

  # Resource routes for FollowRequests
  resources :follow_requests

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
