require "test_helper"

class Api::V1::TypeOfExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @type_of_exercise = type_of_exercises(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get api_v1_type_of_exercises_url, headers: @headers
    assert_response :success
  end

  test "should create type_of_exercise" do
    assert_difference('TypeOfExercise.count') do
      post api_v1_type_of_exercises_url,
           params: {
             type_of_exercise: {
               type_of_exercise: "New Exercise",
               priority: 0,
               difficulty_level: 0,
               main_target: 0
             }
           },
           headers: @headers,
           as: :json
    end
    assert_response :created
  end

  test "should update type_of_exercise" do
    patch api_v1_type_of_exercise_url(@type_of_exercise),
          params: {
            type_of_exercise: {
              type_of_exercise: "Updated Exercise",
              priority: 1,
              difficulty_level: 1,
              main_target: 1
            }
          },
          headers: @headers,
          as: :json
    assert_response :success
  end

  test "should destroy type_of_exercise" do
    assert_difference('TypeOfExercise.count', -1) do
      delete api_v1_type_of_exercise_url(@type_of_exercise), headers: @headers
    end
    assert_response :success
  end
end
