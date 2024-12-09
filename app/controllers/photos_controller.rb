class PhotosController < ApplicationController
  before_action :set_user, only: [:liked_photos, :feed, :discover]
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
    @comments = @photo.comments.includes(:user)
    @user = User.find(params[:id])
    @show_section = params[:show_section] || 'own'
    
    case @show_section
    when 'liked'
      @photos = @user.liked_photos.to_a
      @section_title = 'Liked Photos'
    when 'feed'
      @photos = Photo.where(owner_id: @user.following.pluck(:id)).to_a
      @section_title = 'Feed'
    when 'discover'
      followed_users_ids = @user.following.pluck(:id)
      @photos = Photo.joins(:likes).where(likes: { user_id: followed_users_ids }).distinct.to_a
      @section_title = 'Discover'
    else
      @photos = @user.photos.to_a
      @section_title = 'Own Photos'
    end
  
    render 'show'
  end


  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to users_path, alert: 'User not found.' if @user.nil?
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
    @section_title = "Liked Photos" # Added for clarity in the view
    render 'users/show'  # Assumes that 'users/show' is prepared to handle this context
  end

  def feed
    @user = User.find(params[:id])
    following_ids = @user.following.pluck(:id)
    @photos = Photo.where(owner_id: following_ids).order(created_at: :desc)
    @section_title = "Feed"
    render 'users/show'
  end

  def discover
    followed_users_ids = @user.following.pluck(:id)
    @photos = Photo.joins(:likes)
                   .where(likes: { user_id: followed_users_ids })
                   .distinct
    @section_title = "Discovery"  # Optionally, set a title for display purposes
  
    render 'users/show'
  end

  def my_timeline
    @photos = Photo.where(user_id: current_user.following_ids).order(created_at: :desc)
    render :index 
  end

end
