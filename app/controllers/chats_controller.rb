class ChatsController < ApplicationController
  before_action :set_chat_application, only: %i[index create]
  before_action :set_chat, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /applications/[:token]/chats
  def index
    @chats = Chat.all.where(chat_application_id: @chat_application.id).map(&:as_custom_json)
    render json: @chats
  end

  # GET /applications/[:token]/chats/[:number]
  def show
    render json: @chat.as_custom_json
  end

  # POST /applications/[:token]/chats
  def create
    chat_number = $redis.incr("app:#{params[:token]}:chats_count")
    @chat = Chat.new(number: chat_number, chat_application_id: @chat_application.id)

    if @chat.save
      render json: @chat.as_custom_json, status: :created, location: chat_path(@chat_application.token, chat_number)
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/[:token]/chats/[:number]
  def update
    if @chat.update(chat_params)
      render json: @chat.as_custom_json
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/[:token]/chats/[:number]
  def destroy
    @chat.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat_application
    @chat_application = ChatApplication.find_by!(token: params[:token])
  end

  def set_chat
    set_chat_application

    return unless @chat_application

    @chat = Chat.find_by!(chat_application_id: @chat_application.id, number: params[:number])
  end

  def record_not_found
    render json: { status: 404, error: 'Record not found' }, status: :not_found
  end

  def chat_params
    params.require(:chat).permit(:number, :name)
  end
end
