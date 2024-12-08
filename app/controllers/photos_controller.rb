class PhotosController < ApplicationController
  before_action :set_user, only: [:liked_photos, :feed, :discover]
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    @photos = Photo.all
  end

  def show
    @user = User.find(params[:id])
    @show_section = params[:show_section] || 'own'

    case @show_section
    when 'liked'
      @photos = @user.liked_photos
      @section_title = 'Liked Photos'
    when 'feed'
      @photos = Photo.where(owner_id: @user.following.pluck(:id))
      @section_title = 'Feed'
    when 'discover'
      followed_users_ids = @user.following.pluck(:id)
      @photos = Photo.joins(:likes).where(likes: { user_id: followed_users_ids }).distinct
      @section_title = 'Discover'
    else
      @photos = @user.photos
      @section_title = 'Own Photos'
    end
    @photos = @photos.to_a
    render 'show'
  end


  def set_user
    @user = User.find(params[:id])
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

  def liked_photos
    @photos = @user.liked_photos
    render 'users/show' 
  end

  def discover
    followed_users_ids = @user.following.pluck(:id)
    @photos = Photo.joins(:likes).where(likes: { user_id: followed_users_ids }).distinct
    render 'users/show'
  end

  def my_timeline
    @photos = Photo.where(user_id: current_user.following_ids).order(created_at: :desc)
    render :index 
  end

  def liked_photos
    @user = User.find(params[:user_id])
    @photos = @user.liked_photos # assuming `liked_photos` association exists
  end

end
