require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get current user info" do
    get current_user_api_v1_users_path, headers: @headers
    assert_response :success
  end

  test "should update user" do
    patch update_training_info_api_v1_users_path,
          params: { 
            user: {
              experience_level: "intermediate",
              training_goal: "hypertrophy"
            }
          },
          headers: @headers,
          as: :json
    assert_response :success
  end
end 