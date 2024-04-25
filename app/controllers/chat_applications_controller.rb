class ChatApplicationsController < ApplicationController
  before_action :set_chat_application, only: %i[show update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  # GET /applications
  def index
    @chat_applications = ChatApplication.all.map(&:as_custom_json)
    render json: @chat_applications
  end

  # GET /applications/[:application_token]
  def show
    render json: @chat_application.as_custom_json
  end

  # POST /applications
  def create
    @chat_application = ChatApplication.new(chat_application_params)

    if @chat_application.save
      render json: @chat_application.as_custom_json, status: :created,
             location: chat_application_path(@chat_application.application_token)
    else
      render json: @chat_application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/[:application_token]
  def update
    if @chat_application.update(chat_application_params)
      render json: @chat_application.as_custom_json
    else
      render json: @chat_application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/[:application_token]
  def destroy
    @chat_application.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat_application
    @chat_application = ChatApplication.find_by!(application_token: params[:application_token])
  end

  def resource_not_found
    render json: { status: 404, error: 'Resource not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def chat_application_params
    params.require(:chat_application).permit(:application_token, :name)
  end
end
