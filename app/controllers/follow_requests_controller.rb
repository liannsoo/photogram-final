class FollowRequestsController < ApplicationController
  before_action :set_recipient, only: [:destroy, :cancel]

  def create
    if params[:follow_request].blank? || params[:follow_request][:recipient_id].blank?
      redirect_back fallback_location: users_path, alert: "Invalid follow request."
      return
    end
  
    recipient = User.find_by(id: params[:follow_request][:recipient_id])
    if recipient.nil?
      redirect_back fallback_location: users_path, alert: "User not found."
      return
    end
  
    # Prevent duplicate follow requests
    if current_user.sent_follow_requests.exists?(recipient: recipient)
      redirect_to user_path(recipient), notice: "You have already sent a follow request."
      return
    end
  
    if recipient == current_user
      redirect_to user_path(current_user), notice: "You cannot follow yourself."
    else
      follow_request = current_user.sent_follow_requests.build(recipient: recipient)
      follow_request.status = recipient.private? ? 'pending' : 'accepted'
  
      if follow_request.save
        redirect_back fallback_location: user_path(recipient), notice: recipient.private? ? 'Follow request sent!' : 'Now following!'
      else
        redirect_back fallback_location: users_path, alert: 'Failed to send follow request.'
      end
    end
  end
  
  def destroy
    follow_request = current_user.sent_follow_requests.find_by(recipient_id: params[:id])
    if follow_request&.destroy
      redirect_to user_path(follow_request.recipient), notice: 'Unfollowed successfully.'
    else
      redirect_to user_path(follow_request.recipient), alert: 'Failed to unfollow.'
    end
    if follow_request.nil?
      redirect_back fallback_location: users_path, alert: "Follow request not found."
      return
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

  def accept
    follow_request = FollowRequest.find(params[:id])
    
    if follow_request && follow_request.recipient == current_user
      follow_request.update(status: 'accepted')
      redirect_to user_path(current_user), notice: 'Follow request accepted.'
    else
      redirect_to user_path(current_user), alert: 'Invalid follow request or you do not have the permission to accept this request.'
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Follow request not found.'
  end  

  def reject
    follow_request = FollowRequest.find_by(id: params[:id], recipient: current_user)
  
    if follow_request
      follow_request.destroy
      redirect_to user_path(current_user), notice: 'Follow request rejected.'
    else
      redirect_to user_path(current_user), alert: 'Failed to find or reject the follow request.'
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Follow request not found.'
  end

  private

  def set_recipient
    @recipient = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: "User not found."
  end
end
