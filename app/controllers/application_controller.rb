class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except: [:top,:about,]
  before_action :allow_logout_only_when_logged_in, only: [:logout]
  
  def after_sign_in_path_for(resource)
    user_path(resource.id)
  end
  
  def after_sign_out_path_for(resource)
    root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :introduction])
    devise_parameter_sanitizer.permit(:log_in, keys: [:name, :introduction])
  end
  
  def allow_logout_only_when_logged_in
    redirect_to root_path unless user_signed_in?
  end
  
end
