class ApplicationController < ActionController::Base
 before_action :authenticate_user!, except: [:top], unless: :admin_controller?
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    posts_path
  end
  
  private
 
  def admin_controller?
    self.class.module_parent_name == 'Admin'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nick_name, :family_name, :first_name, :family_name_kana, :first_name_kana])
  end
end
