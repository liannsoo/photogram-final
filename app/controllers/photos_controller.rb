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
    # Correctly use 'fan_id' if your Like model has a 'fan' relationship with the User
    new_like = @photo.likes.create(fan_id: current_user.id)
  
    if new_like.persisted?
      flash[:notice] = "Photo liked successfully."
    else
      flash[:alert] = "Failed to like the photo."
    end
  
    # Redirect back to the same photo's detail page
    redirect_to photo_path(@photo)
  end
  
  def unlike
    @photo = Photo.find(params[:id])
    like = @photo.likes.find_by(fan_id: current_user.id)
  
    if like&.destroy
      flash[:notice] = "Like removed."
    else
      flash[:alert] = "Failed to remove like."
    end
  
    redirect_to photo_path(@photo)
  end

  def photo_params
    params.require(:photo).permit(:caption, :image)  
  end

  def feed
    # Retrieves all photos from users this user is following
    @photos = current_user.feed_photos
    render :index 
  end

  def my_timeline
    @photos = Photo.where(user_id: current_user.following_ids).order(created_at: :desc)
    render :index  # or render a specific view for 'my_timeline' if you have one
  end


end
