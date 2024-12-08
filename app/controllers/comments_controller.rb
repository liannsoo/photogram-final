class CommentsController < ApplicationController
  before_action :set_photo

  def create
    @comment = @photo.comments.build(comment_params) # Associate comment with the photo
    @comment.author_id = current_user.id
    if @comment.save
      redirect_to photo_path(@comment.photo), notice: "Comment added successfully."
    else
      redirect_to photo_path(@comment.photo), alert: "Failed to add comment."
    end
  end

  private

  def set_photo
    @photo = Photo.find(params[:photo_id]) # Ensure `photo_id` comes from the nested route
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
