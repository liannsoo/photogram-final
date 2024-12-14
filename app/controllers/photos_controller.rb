class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    if user_signed_in?
      # Show all public photos + photos from users the current user follows
      public_user_ids = User.where(private: false).pluck(:id)
      followed_user_ids = current_user.following.pluck(:id)
      visible_user_ids = (public_user_ids + followed_user_ids).uniq
      @photos = Photo.where(owner_id: visible_user_ids).order(created_at: :desc)
    else
      # Show only public photos for non-signed-in users
      public_user_ids = User.where(private: false).pluck(:id)
      @photos = Photo.where(owner_id: public_user_ids).order(created_at: :desc)
    end
  end
  
  def show
    @photo = Photo.find_by(id: params[:id])
    if @photo.nil?
      redirect_to photos_path, alert: 'Photo not found.'
      return
    end
    @comments = @photo.comments.includes(:author)
    @user = @photo.owner
    @show_section = params[:show_section] || 'own'
  end

  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      redirect_to photos_path, notice: 'Photo created successfully.'
    else
      @photos = Photo.all
      render :index, alert: 'Failed to add photo.'
    end
  end

  def edit
  end

  def update
    if @photo.update(photo_params)
      redirect_to photo_path(@photo), notice: 'Photo updated successfully.'
    else
      render :edit, alert: 'Failed to update photo.'
    end
  end

  def destroy
    @photo.destroy
    redirect_to photos_path, notice: 'Photo deleted successfully.'
  end

  def like
    @photo = Photo.find(params[:id])
    new_like = @photo.likes.create(fan_id: current_user.id)
    flash[:notice] = 'Like created successfully.'
    redirect_to photo_path(@photo)
  end
  
  def unlike
    @photo = Photo.find(params[:id])
    @photo.likes.where(fan_id: current_user.id).destroy_all
    flash[:alert] = 'Like deleted successfully.'
    redirect_to photo_path(@photo)
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:caption, :image)  
  end
end
