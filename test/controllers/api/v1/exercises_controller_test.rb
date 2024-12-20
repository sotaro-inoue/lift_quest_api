require "test_helper"

class Api::V1::ExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @workout_log = workout_logs(:one)
    @exercise = exercises(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get api_v1_workout_log_exercises_url(@workout_log), headers: @headers
    assert_response :success
  end

  test "should create exercise" do
    assert_difference('Exercise.count') do
      post api_v1_workout_log_exercises_url(@workout_log),
          params: {
            exercise: {
              type_of_exercise_id: type_of_exercises(:one).id,
              exercise_name: "Test Exercise",
              weight: 100.0,
              reps: 10,
              sets: 3
            }
          },
          headers: @headers,
          as: :json
    end
    assert_response :created
  end

  test "should update exercise" do
    patch api_v1_exercise_url(@exercise), 
          params: {
            exercise: {
              weight: 120.0,
              reps: 8,
              sets: 4,
              type_of_exercise_id: @exercise.type_of_exercise_id
            }
          },
          headers: @headers,
          as: :json
    assert_response :success
  end

  test "should destroy exercise" do
    assert_difference('Exercise.count', -1) do
      delete api_v1_exercise_url(@exercise), headers: @headers
    end
    assert_response :success
  end
end
