class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def feed_photos
    Photo.joins(:owner => :received_follow_requests)
         .where(follow_requests: { sender_id: id, status: 'accepted' })
  end
end
