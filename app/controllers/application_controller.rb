class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  USER_MAX_TEAMS = 6
  USER_MAX_CREATE_TEAMS = 5
  TEAM_MAX_MEMBERS = 6

  protected
    def configure_permitted_parameters
       devise_parameter_sanitizer.for(:sign_up)        << [:first_name, :last_name]
       devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name, :description]
    end
    
    def authenticate_admin!
      if authenticate_user! && (current_user.admin? || current_user.host?)
        true
      else
        redirect_to root_path, alert: 'No access'
      end
    end
    
end
