class MessagesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    #@message = Message.new(user_id: current_user.id, conversation_id: params[:id], )
    @message = current_user.messages.build(message_params)
    if @message.save
      flash[:success] = "Your message was sent."
      redirect_to request.referrer
    else
      flash[:danger] = "#{p params}}"
      #flash[:danger] = "Something went wrong. Try again later. Conversation id: #{params[:id]} #{ @message.id } - #{ @message.content } - #{ @message.conversation_id }"
      redirect_to request.referrer
    end
  end
  private

  def message_params
    #This needs to contain the conversation ID as well
    params.require(:message).permit(:content, :conversation_id, :user_id)
  end
  def logged_in_user
    unless user_signed_in?
      flash[:danger] = "Log in first to be able to chat."
      redirect_to login_url
    end
  end
end
