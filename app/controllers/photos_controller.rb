class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
    @comments = @photo.comments.includes(:user)
    @user = User.find(params[:id])
    @show_section = params[:show_section] || 'own'
  end

  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      flash[:notice] = 'Photo added successfully.'
      redirect_to photos_path
    else
      flash[:alert] = 'Failed to add photo.'
      render :new
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
    flash[:alert] = 'You unliked this photo.'
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
