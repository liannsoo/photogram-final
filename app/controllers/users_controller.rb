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
    Rails.logger.debug "Followed user IDs: #{@user.following.pluck(:id)}"
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

    if @user.private? && user_signed_in? && !@user.received_follow_requests.where(sender: current_user, status: 'accepted').exists?
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
                followed_users_ids = @user.following.pluck(:id)
                if followed_users_ids.any?
                  Photo.where(owner_id: followed_users_ids).order(created_at: :desc)
                else
                  [] # No photos to show if no followed users
                end
              when 'liked_photos'
                @user.liked_photos || [] # Use empty array as a fallback
              when 'discover'
                followed_users_ids = @user.following.pluck(:id)
                if followed_users_ids.any?
                  Photo.joins(:likes).where(likes: { fan_id: followed_users_ids }).distinct
                else
                  [] # No photos if no followed users
                end
              else
                @user.photos || [] # Fallback for user's own photos
              end
              Rails.logger.debug "Discovered photos: #{@photos.map(&:id)}"
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
