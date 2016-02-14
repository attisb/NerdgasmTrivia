class EventsController < ApplicationController
  
  def index
    @events = Event.where(visible: true).where("date_start > ?", Time.now.beginning_of_day).paginate(:page => params[:page]).order(date_start: :asc)
  end
  
  def show
    @event = Event.find(params[:id])
  end
  
  def join
    event = Event.find_by(code: params[:code])
    user = Score.find_by(event_id: event.id, user_id: current_user.id) unless event.nil?
    if user_signed_in? && (!current_user.admin? || !current_user.host?)
      if event.nil?
        redirect_to root_path, alert: "Can't find the event"
      else
        if user.nil?
          Score.find_or_create_by(event_id: event.id, user_id: current_user.id, team_id: params[:team], points: event.bonus)
          redirect_to root_path, notice: "Joined event"
        else
          redirect_to root_path, alert: "Already playing this event"
        end
      end
    else
      redirect_to root_path, alert: "Not allowed to join events"
    end
  end
  
end
