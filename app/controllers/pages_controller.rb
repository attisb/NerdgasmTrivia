class PagesController < ApplicationController
  def index
    @events = Event.where(visible: true).where("date_start > ?", Time.now.beginning_of_day).order(date_start: :asc).limit(3)
  end
  
  def store
  end
  
  def hire
  end
end
