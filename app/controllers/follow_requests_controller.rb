class FollowRequestsController < ApplicationController
  def create
    @follow_request = current_user.sent_follow_requests.build(recipient_id: params[:recipient_id])
    if @follow_request.save
    redirect_back fallback_location: root_path, notice: 'Follow request sent.'
    else
    redirect_back fallback_location: root_path, alert: 'Could not send follow request.'
    end
  end

  def update
  end

  def destroy
    @follow_request = FollowRequest.find(params[:id])
    @follow_request.destroy
    redirect_back fallback_location: root_path, notice: 'Follow request cancelled.'
  end
end
