class FollowRequestsController < ApplicationController
  def create
    return redirect_to user_path(@recipient) if current_user == @recipient
    follow_request = current_user.sent_follow_requests.build(recipient: @recipient)
    follow_request.status = @recipient.private? ? 'pending' : 'accepted'
    if follow_request.save
      redirect_to user_path(@recipient), notice: 'Follow request sent!'
    else
      redirect_to user_path(@recipient), alert: 'Failed to send follow request.'
    end
  end

  def destroy
    follow_request = current_user.sent_follow_requests.find_by(recipient: @recipient)
    if follow_request&.destroy
      redirect_to user_path(@recipient), notice: 'Unfollowed successfully.'
    else
      redirect_to user_path(@recipient), alert: 'Failed to unfollow.'
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
    @recipient = User.find(params[:follow_request][:recipient_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: "User not found."
  end
end
