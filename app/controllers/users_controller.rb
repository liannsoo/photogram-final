class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    @users = User.all
    if user_signed_in?
      @follow_statuses = current_user.sent_follow_requests.pluck(:recipient_id, :status).to_h
    else
      @follow_statuses = {}
    end
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      redirect_to root_path, alert: "User not found."
      return
    end
  
    # Check access for private accounts
  if @user.private? && !user_signed_in?
    redirect_to root_path, alert: "You must be signed in to view this user's profile."
    return
  end

  if @user.private? && user_signed_in? && !current_user.received_follow_requests.where(sender_id: @user.id, status: 'accepted').exists?
    redirect_to root_path, alert: "You do not have permission to view this user's profile."
    return
  end

  # Fetch follow statuses if signed in
  if user_signed_in?
    @follow_statuses = current_user.sent_follow_requests.pluck(:recipient_id, :status).to_h
  else
    @follow_statuses = {}
  end

  # Determine which section to show
  @show_section = params[:show_section] || 'own'
  @photos = case @show_section
            when 'feed'
              Photo.where(owner_id: @user.following.pluck(:id)).order(created_at: :desc)
            when 'liked_photos'
              @user.liked_photos
            when 'discover'
              followed_users_ids = @user.following.pluck(:id)
              Photo.joins(:likes).where(likes: { owner_id: followed_users_ids }).distinct
            else
              @user.photos
            end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "User not found."
      false # Return false to halt the callback chain
    end
  end
end
