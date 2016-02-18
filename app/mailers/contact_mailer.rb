class ContactMailer < ApplicationMailer
  default from: "Nerdgasm Contact <contact@nerdgasmtrivia.com>"
  default to: "Nerdgasm Contact <contact@nerdgasmtrivia.com>"

  def new_message(message)
    @message = message
  
    mail subject: "Message from #{message.name}"
  end
end
