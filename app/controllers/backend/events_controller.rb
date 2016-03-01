class Backend::EventsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    if params[:s]
      @events = Event.where('name LIKE :search', search: params[:s]).paginate(:page => params[:page])
    else
      @events = Event.where("date_start > ?", Time.now.beginning_of_day).paginate(:page => params[:page])
    end

    @past_events = Event.where("date_start < ?", Time.now.beginning_of_day).limit(5)
  end
  
  def new
    @event = Event.new(bonus: 0)
		@hosts = User.where(host: true).map { |user| ["#{user.first_name} #{user.last_name}", user.id] }
  end
  
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user
    if @event.save
      redirect_to backend_events_path, notice: "Event created"
    else
      render :new
    end
  end
  
  def edit
    unless current_user.id == @event.user_id || current_user.admin?
      redirect_to backend_events_path, alert: 'Not allowed to modify event by someone else.'
    end
  end
  
  def update
    if @event.update(event_params)
      redirect_to backend_events_path, notice: 'Event updated'
    else
      render :edit
    end
  end
  
  def destroy
    if user_signed_in? && (@event.user == current_user.id || current_user.admin?)
      scores = Score.where(event_id: @event.id)
      scores.destroy_all
      @event.destroy
      redirect_to backend_events_path, notice: "Deleted event."
    else
      redirect_to backend_events_path, alert: "Unable to delete event."
    end
  end
  
  
  private
    def set_event
      @event = Event.find(params[:id])
  		@hosts = User.where(host: true).map { |user| ["#{user.first_name} #{user.last_name}", user.id] }
    end

    def event_params
      params.require(:event).permit(:name, :description, :date_start, :date_end, :visible, :bonus, :user_id)
    end

end
