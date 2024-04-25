class ChatsController < ApplicationController
  before_action :set_chat_application
  before_action :set_chat, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  # GET /applications/[:application_token]/chats
  def index
    @chats = Chat.all.where(chat_application_id: @chat_application.id).map(&:as_custom_json)
    render json: @chats
  end

  # GET /applications/[:application_token]/chats/[:chat_number]
  def show
    render json: @chat.as_custom_json
  end

  # POST /applications/[:application_token]/chats
  def create
    chat_number = $redis.incr("chat_application:#{@chat_application.id}:chats_count")
    @chat = Chat.new(chat_number:, chat_application_id: @chat_application.id)

    if @chat.save
      render json: @chat.as_custom_json, status: :created,
             location: chat_path(@chat_application.application_token, chat_number)
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/[:application_token]/chats/[:chat_number]
  def update
    if @chat.update(chat_params)
      render json: @chat.as_custom_json
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/[:application_token]/chats/[:chat_number]
  def destroy
    @chat.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat_application
    @chat_application = ChatApplication.find_by!(application_token: params[:application_token])
  end

  def set_chat
    @chat = Chat.find_by!(chat_application_id: @chat_application.id, chat_number: params[:chat_number])
  end

  def resource_not_found
    render json: { status: 404, error: 'Resource not found' }, status: :not_found
  end

  def chat_params
    params.require(:chat).permit(:application_token, :chat_number, :name)
  end
end
