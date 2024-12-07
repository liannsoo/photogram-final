class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :debug_current_user, unless: :devise_controller?
  protect_from_forgery with: :exception

  protected

  def debug_current_user
    if Rails.env.development?
      Rails.logger.debug "Current User: #{current_user.inspect}"
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :username])
  end

  def after_sign_in_path_for(resource)
    users_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
