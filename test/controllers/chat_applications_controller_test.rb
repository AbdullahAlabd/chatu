require "test_helper"

class ChatApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat_application = chat_applications(:one)
  end

  test "should get index" do
    get chat_applications_url, as: :json
    assert_response :success
  end

  test "should create chat_application" do
    assert_difference("ChatApplication.count") do
      post chat_applications_url, params: { chat_application: { chats_count: @chat_application.chats_count, deleted_at: @chat_application.deleted_at, name: @chat_application.name, token: @chat_application.token } }, as: :json
    end

    assert_response :created
  end

  test "should show chat_application" do
    get chat_application_url(@chat_application), as: :json
    assert_response :success
  end

  test "should update chat_application" do
    patch chat_application_url(@chat_application), params: { chat_application: { chats_count: @chat_application.chats_count, deleted_at: @chat_application.deleted_at, name: @chat_application.name, token: @chat_application.token } }, as: :json
    assert_response :success
  end

  test "should destroy chat_application" do
    assert_difference("ChatApplication.count", -1) do
      delete chat_application_url(@chat_application), as: :json
    end

    assert_response :no_content
  end
end
