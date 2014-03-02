class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
    
  layout :layout

  protected

  def layout
    # only turn it off for login pages:
    is_a?(Devise::SessionsController) ? false : "application"
    # or turn layout off for every devise controller:
    !devise_controller? && "application"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit :username, :email, :password, :password_confirmation, :current_password
    end
  end
end
