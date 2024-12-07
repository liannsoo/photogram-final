class FollowRequestsController < ApplicationController
  def create
    recipient = User.find(params[:follow_request][:recipient_id])
    follow_request = current_user.sent_follow_requests.build(recipient: recipient)
    follow_request.status = recipient.private? ? 'pending' : 'accepted'

    if follow_request.save
      redirect_to users_path, notice: 'Follow request sent!'
    else
      redirect_to users_path, alert: 'Failed to send follow request.'
    end
  end

  def destroy
    follow_request = FollowRequest.find_by(sender: current_user, recipient_id: params[:id])
    if follow_request&.destroy
      redirect_to users_path, notice: 'Unfollowed successfully.'
    else
      redirect_to users_path, alert: 'Failed to unfollow.'
    end
  end

  def cancel
    follow_request = FollowRequest.find_by(sender: current_user, recipient_id: params[:id], status: 'pending')
    if follow_request&.destroy
      redirect_to users_path, notice: 'Follow request canceled.'
    else
      redirect_to users_path, alert: 'Failed to cancel follow request.'
    end
  end
end
