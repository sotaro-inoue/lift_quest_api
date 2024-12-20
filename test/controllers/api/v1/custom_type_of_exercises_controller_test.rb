require "test_helper"

class Api::V1::CustomTypeOfExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @type_of_exercise = type_of_exercises(:one)
    @custom_type_of_exercise = custom_type_of_exercises(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get api_v1_custom_type_of_exercises_url, headers: @headers
    assert_response :success
  end

  test "should create custom_type_of_exercise" do
    assert_difference('CustomTypeOfExercise.count') do
      post api_v1_custom_type_of_exercises_url,
           params: {
             custom_type_of_exercise: {
               name: "My Custom Exercise",
               type_of_exercise_id: @type_of_exercise.id
             }
           },
           headers: @headers,
           as: :json
    end
    assert_response :created
  end

  test "should update custom_type_of_exercise" do
    patch api_v1_custom_type_of_exercise_url(@custom_type_of_exercise),
          params: {
            custom_type_of_exercise: {
              name: "Updated Custom Exercise"
            }
          },
          headers: @headers,
          as: :json
    assert_response :success
  end

  test "should destroy custom_type_of_exercise" do
    assert_difference('CustomTypeOfExercise.count', -1) do
      delete api_v1_custom_type_of_exercise_url(@custom_type_of_exercise),
             headers: @headers
    end
    assert_response :success
  end
end 