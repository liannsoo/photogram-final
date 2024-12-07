class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_forgery_protection

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username])
  end
  
  def after_sign_in_path_for(resource)
    users_path
  end
end
