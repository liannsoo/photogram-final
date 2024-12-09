class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    @users = User.all
    if user_signed_in?
      @follow_requests = current_user.sent_follow_requests.includes(:recipient)
      @follow_statuses = @follow_requests.map { |fr| [fr.recipient_id, fr.status] }.to_h
    else
      @follow_statuses = {}
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  
    if user_signed_in?
      @follow_statuses = current_user.sent_follow_requests.includes(:recipient)
                                     .map { |fr| [fr.recipient_id, fr.status] }.to_h
    else
      @follow_statuses = {}
    end

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
