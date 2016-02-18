class ContactsController < ApplicationController
  def new
      @message = Contact.new
    end

    def create
      @message = Contact.new(message_params)
    
      if @message.valid?
        ContactMailer.new_message(@message).deliver
        redirect_to hire_path, notice: "Your messages has been sent."
      else
        redirect_to hire_path, alert: "An error occurred while delivering this message."
      end
    end

  private
    def message_params
      params.require(:contact).permit(:name, :email, :content)
    end
end
