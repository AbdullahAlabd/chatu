class ChatApplicationsController < ApplicationController
  before_action :set_chat_application, only: %i[show update destroy]

  # GET /applications
  def index
    @chat_applications = ChatApplication.all
    render json: @chat_applications.map(&:as_custom_json)
  end

  # GET /applications/[:token]
  def show
    render json: @chat_application.as_custom_json
  end

  # POST /applications
  def create
    @chat_application = ChatApplication.new(chat_application_params)

    if @chat_application.save
      print '@bl7'
      render json: @chat_application.as_custom_json, status: :created,
             location: chat_application_path(@chat_application.token)
    else
      render json: @chat_application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/[:token]
  def update
    if @chat_application.update(chat_application_params)
      render json: @chat_application.as_custom_json
    else
      render json: @chat_application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/[:token]
  def destroy
    @chat_application.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat_application
    @chat_application = ChatApplication.find_by!(token: params[:token])
  end

  # Only allow a list of trusted parameters through.
  def chat_application_params
    params.require(:chat_application).permit(:name)
  end
end
