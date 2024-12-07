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

  def photo_params
    params.require(:photo).permit(:caption, :image)  # Include other fields as needed
  end

  def feed
    # Retrieves all photos from users this user is following
    @photos = current_user.feed_photos
    render :index  # You can reuse the index view or create a specific feed view if needed
  end

  def discovery
    # Retrieves photos liked by users this user is following
    @photos = current_user.discovery_photos
    render :index  # Reuse the index view or create a specific discovery view
  end
end
