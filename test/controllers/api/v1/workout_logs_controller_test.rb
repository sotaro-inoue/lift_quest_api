require "test_helper"

class Api::V1::WorkoutLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_workout_logs_url
    assert_response :success
  end

  test "should get show" do
    workout_log = workout_logs(:one)
    get api_v1_workout_log_url(workout_log)
    assert_response :success
  end

  test "should create workout_log" do
    assert_difference("WorkoutLog.count") do
      post api_v1_workout_logs_url, params: { 
        workout_log: { 
          exercise_name: "デッドリフト",
          type_of_exercise: "背中",
          weight: 100.0,
          reps: 5,
          sets: 3
        } 
      }
    end
    assert_response :success
  end

  test "should update workout_log" do
    workout_log = workout_logs(:one)
    patch api_v1_workout_log_url(workout_log), params: { 
      workout_log: {
        exercise_name: "ベンチプレス",
        type_of_exercise: "胸",
        weight: 80.0,
        reps: 8,
        sets: 4
      } 
    }
    assert_response :success
  end

  test "should destroy workout_log" do
    workout_log = workout_logs(:one)
    assert_difference("WorkoutLog.count", -1) do
      delete api_v1_workout_log_url(workout_log)
    end
    assert_response :success
  end
end
