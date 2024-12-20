require "test_helper"

class Api::V1::WorkoutLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @workout_log = workout_logs(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get api_v1_workout_logs_url, headers: @headers
    assert_response :success
  end

  test "should get show" do
    get api_v1_workout_log_url(@workout_log), headers: @headers
    assert_response :success
  end

  test "should create workout_log" do
    assert_difference('WorkoutLog.count') do
      post api_v1_workout_logs_url,
           params: {
             workout_log: {
               notes: "Test workout"
             }
           },
           headers: @headers,
           as: :json
    end
    assert_response :created
  end

  test "should update workout_log" do
    patch api_v1_workout_log_url(@workout_log),
          params: {
            workout_log: {
              notes: "Updated workout"
            }
          },
          headers: @headers,
          as: :json
    assert_response :success
  end

  test "should destroy workout_log" do
    assert_difference('WorkoutLog.count', -1) do
      delete api_v1_workout_log_url(@workout_log), headers: @headers
    end
    assert_response :success
  end
end
