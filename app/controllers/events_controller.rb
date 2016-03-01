class EventsController < ApplicationController
  
  def index
    @events = Event.where(visible: true).where("date_start > ?", Time.now.beginning_of_day).paginate(:page => params[:page]).order(date_start: :asc)
  end
  
  def show
    @event = Event.find(params[:id])
  end
  
  def join
    event = Event.find_by(code: params[:code].downcase)
    user = Score.find_by(event_id: event.id, user_id: current_user.id) unless event.nil?
    event_team_count = Score.where(event_id: event.id, team_id: params[:team]).count
    if user_signed_in? && (!current_user.admin? || !current_user.host?)
      if event.nil?
        if params[:speed]
          redirect_to speed_path, alert: "Sorry we can't find that event."
        else
          redirect_to root_path, alert: "Sorry we can't find that event."
        end
      else
        if user.nil?
          if event_team_count >= ApplicationController::TEAM_MAX_MEMBERS
            if params[:speed]
              redirect_to speed_path, alert: 'Sorry this team already has the max amount of players.'
            else
              redirect_to edit_user_registration_path, alert: 'Sorry this team already has the max amount of players.'
            end
          else
            if event.date_end.past?
              if params[:speed]
                redirect_to speed_path, alert: "Ouch! Event has already past."
              else
                redirect_to root_path, alert: "Ouch! Event has already past."
              end
            else
              Score.find_or_create_by(event_id: event.id, user_id: current_user.id, team_id: params[:team], points: event.bonus)
              if params[:speed]
                redirect_to speed_path, notice: "Awesome! You have successfully joined the event."
              else
                redirect_to root_path, notice: "Awesome! You have successfully joined the event."
              end
            end
          end
        else
          if params[:speed]
            redirect_to speed_path, alert: "Ouch! You are already playing at this event."
          else
            redirect_to root_path, alert: "Ouch! You are already playing at this event."
          end
        end
      end
    else
      if params[:speed]
        redirect_to speed_path, alert: "Sorry you're not allowed to join this event."
      else
        redirect_to root_path, alert: "Sorry you're not allowed to join this event."
      end
    end
  end
  
end
