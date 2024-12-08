class PhotosController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
    @comments = @photo.comments
  end

  def new
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
  end

  def destroy
  end

  def like
    @photo = Photo.find(params[:id])
    # Correctly use 'fan_id' if your Like model has a 'fan' relationship with the User
    new_like = @photo.likes.create(fan_id: current_user.id)
    flash[:notice] = 'You liked this photo.'
    redirect_to photo_path(@photo)
  end
  
  def unlike
    @photo = Photo.find(params[:id])
    @photo.likes.where(fan_id: current_user.id).destroy_all
    flash[:alert] = 'You unliked this photo.'
  
    redirect_to photo_path(@photo)
  end

  def photo_params
    params.require(:photo).permit(:caption, :image)  
  end

  def feed
    # Retrieves all photos from users this user is following
    @photos = Photo.where(user_id: current_user.following_ids).order(created_at: :desc)
  end

  def my_timeline
    @photos = Photo.where(user_id: current_user.following_ids).order(created_at: :desc)
    render :index  # or render a specific view for 'my_timeline' if you have one
  end


end
