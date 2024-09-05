class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  private
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
  
  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
  
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  
  def after_update_path_for(resource)
    # 自分で設定した「マイページ」へのパス
    user_path(current_user)
  end
  
end
