class PagesController < ApplicationController
  def index
    @events = Event.where(visible: true).where("date_start > ?", Time.now.beginning_of_day).order(date_start: :asc).limit(3)
  end
  
  def store
    redirect_to "https://nerdgasmapparel.com?trivia"
  end
  
  def hire
    @message = Contact.new
  end
  
  def profile
    @user = User.find(params[:id])
    set_badge_arrays
  end
  
  def changelog
  end
  
end
