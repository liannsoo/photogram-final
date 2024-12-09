class FollowRequestsController < ApplicationController
  before_action :set_recipient, only: [:destroy, :cancel]

  def create
    recipient = User.find(params[:follow_request][:recipient_id])
    # Redirect to user's profile if trying to follow themselves
    if recipient == current_user
      redirect_to user_path(current_user), notice: "You cannot follow yourself."
    else
      follow_request = current_user.sent_follow_requests.build(recipient: recipient)
      follow_request.status = recipient.private? ? 'pending' : 'accepted'
    
      if follow_request.save
        redirect_back fallback_location: users_path, notice: 'Follow request sent!'
      else
        redirect_back fallback_location: users_path, alert: 'Failed to send follow request.'
      end
    end

  def destroy
    follow_request = current_user.sent_follow_requests.find_by(recipient_id: params[:id])
    if follow_request&.destroy
      if follow_request.recipient.private?
        redirect_to users_path, notice: 'Unfollowed successfully.'
      else
        redirect_to user_path(follow_request.recipient), notice: 'Unfollowed successfully.'
      end
    else
      redirect_to user_path(follow_request.recipient), alert: 'Failed to unfollow.'
    end
  end

  def cancel
    follow_request = current_user.sent_follow_requests.find_by(recipient: @recipient, status: 'pending')
    if follow_request&.destroy
      redirect_to user_path(@recipient), notice: 'Follow request canceled.'
    else
      redirect_to user_path(@recipient), alert: 'Failed to cancel follow request.'
    end
  end

  private

  def set_recipient
    @recipient = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: "User not found."
  end
end
