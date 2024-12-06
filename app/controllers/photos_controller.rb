class PhotosController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def new
  end

  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      redirect_to photos_path, notice: 'Photo was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def like
    @photo = Photo.find(params[:id])
    @photo.likes.create(user: current_user)
    flash[:notice] = "Photo liked successfully."
    redirect_to photos_path
  end
  
  def unlike
    @photo = Photo.find(params[:id])
    @photo.likes.find_by(user: current_user)&.destroy
    flash[:alert] = "Photo unliked successfully."
    redirect_to photos_path
  end

  def photo_params
    params.require(:photo).permit(:caption, :image)  
  end

  def feed
    # Retrieves all photos from users this user is following
    @photos = current_user.feed_photos
    render :index 
  end

  def feed
    @photos = current_user.feed_photos
    render :index
  end

end
