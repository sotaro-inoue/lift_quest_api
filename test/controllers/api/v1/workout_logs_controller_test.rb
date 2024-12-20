require "test_helper"

class Api::V1::WorkoutLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @workout_log = workout_logs(:one)
  end

  test "should get index" do
    get api_v1_workout_logs_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_workout_log_url(@workout_log)
    assert_response :success
  end

  test "should create workout_log" do
    post api_v1_workout_logs_url, params: { workout_log: {} }
    assert_response :success
  end

  test "should update workout_log" do
    patch api_v1_workout_log_url(@workout_log), params: { workout_log: {} }
    assert_response :success
  end

  test "should destroy workout_log" do
    delete api_v1_workout_log_url(@workout_log)
    assert_response :success
  end
end
