class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
    if user_signed_in?
      @follow_requests = current_user.sent_follow_requests.includes(:recipient)
      @follow_statuses = @follow_requests.map { |fr| [fr.recipient_id, fr.status] }.to_h
    else
      @follow_statuses = {}
    end
  end

  def feed_photos
    Photo.joins(:owner => :received_follow_requests)
         .where(follow_requests: { sender_id: id, status: 'accepted' })
  end
end
