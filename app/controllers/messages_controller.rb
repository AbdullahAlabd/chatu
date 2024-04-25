class MessagesController < ApplicationController
  before_action :set_chat_application
  before_action :set_chat
  before_action :set_message, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  # GET /applications/:application_token/chats/:chat_number/messages
  def index
    @messages = Message.all.where(chat_id: @chat.id).map(&:as_custom_json)

    render json: @messages
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:message_number
  def show
    render json: @message.as_custom_json
  end

  # POST /applications/:application_token/chats/:chat_number/messages
  def create
    message_number = $redis.incr("chat:#{@chat.id}:messages_count")
    @message = Message.new(chat_id: @chat.id, message_number:, content: params[:content])
    if @message.save
      render json: @message.as_custom_json, status: :created,
             location: message_path(@chat_application.application_token, @chat.chat_number, message_number)
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number/messages/:message_number
  def update
    if @message.update(message_params)
      render json: @message.as_custom_json
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:chat_number/messages/:message_number
  def destroy
    @message.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat_application
    @chat_application = ChatApplication.find_by!(application_token: params[:application_token])
  end

  def set_chat
    @chat = Chat.find_by!(chat_application_id: @chat_application.id, chat_number: params[:chat_number])
  end

  def set_message
    @message = Message.find_by!(chat_id: @chat.id, message_number: params[:message_number])
  end

  def resource_not_found
    render json: { status: 404, error: 'Resource not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:application_token, :chat_number, :message_number, :content)
  end
end
