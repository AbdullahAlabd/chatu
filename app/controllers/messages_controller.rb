class MessagesController < ApplicationController
  before_action :set_chat_application
  before_action :set_chat
  before_action :set_message, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /messages
  def index
    @messages = Message.all.where(chat_id: @chat.id).map(&:as_custom_json)

    render json: @messages
  end

  # GET /messages/1
  def show
    render json: @message.as_custom_json
  end

  # POST /messages
  def create
    message_number = $redis.incr("chat:#{@chat.id}:messages_count")
    @message = Message.new(chat_id: @chat.id, number: message_number, content: params[:content])
    if @message.save
      render json: @message.as_custom_json, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message.as_custom_json
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat_application
    @chat_application = ChatApplication.find_by!(token: params[:token])
  end

  def set_chat
    @chat = Chat.find_by!(chat_application_id: @chat_application.id, number: params[:number])
  end

  def set_message
    @message = Message.find_by!(chat_id: @chat.id, number: params[:message_number])
  end

  def record_not_found
    render json: { status: 404, error: 'Record not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:token, :number, :message_number, :content)
  end
end
