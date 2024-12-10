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
    # Redirect if user not found
  unless @user
    redirect_to root_path, alert: "User not found."
    return
  end
  
  # Redirect if user needs to be signed in to see a private profile
  if @user.private? && !user_signed_in?
    redirect_to root_path, alert: "You must be signed in to view this user's profile."
    return
  end

  # Redirect if the current user doesn't have permission to view the private profile
  if @user.private? && user_signed_in? && !@user.received_follow_requests.where(sender: current_user, status: 'accepted').exists?
    redirect_to root_path, alert: "You do not have permission to view this user's profile."
    return
  end

    @follow_statuses = user_signed_in? ? current_user.sent_follow_requests.pluck(:recipient_id, :status).to_h : {}

    # Determine which section to show
    @show_section = params[:show_section] || 'own'
    @photos = case @show_section
    when 'feed'
      followed_users_ids = @user.following.pluck(:id)
      Photo.where(owner_id: followed_users_ids).order(created_at: :desc) if followed_users_ids.any?
    when 'liked_photos'
      @user.liked_photos
    when 'discover'
      followed_users_ids = @user.following.pluck(:id)
      Photo.joins(:likes).where(likes: { fan_id: followed_users_ids }).distinct if followed_users_ids.any?
    else
      @user.photos
    end || []
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to root_path, alert: "User not found."
      false
    end
  end
end
