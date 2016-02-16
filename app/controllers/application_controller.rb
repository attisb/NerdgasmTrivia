class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  USER_MAX_TEAMS = 6
  USER_MAX_CREATE_TEAMS = 5
  TEAM_MAX_MEMBERS = 6
  BADGE_TYPES = [
    ["Events Played", "event"],
    ["User Score", "scoreu"],
    ["Team Score", "scoret"],
    ["Teams Joined", "teamj"]
  ]

  protected
    def configure_permitted_parameters
       devise_parameter_sanitizer.for(:sign_up)        << [:first_name, :last_name]
       devise_parameter_sanitizer.for(:account_update) << [:first_name, :last_name, :description]
    end
    
    def authenticate_admin!
      if authenticate_user! && (current_user.admin? || current_user.host?)
        true
      else
        redirect_to root_path
      end
    end
    
    def set_badge_arrays
      @badges_userscore = Badge.where(badge_type: 'scoreu').where("trigger <= ?", @user.scores.sum(:points))
      @badges_teamscore = Badge.where(badge_type: 'event').where("trigger <= ?", @user.scores.count)
    end
    
end
