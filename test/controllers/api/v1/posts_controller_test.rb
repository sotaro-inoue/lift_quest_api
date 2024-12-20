require "test_helper"

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get api_v1_posts_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_post_url(@post)
    assert_response :success
  end

  test "should create post" do
    post api_v1_posts_url, params: { post: {} }
    assert_response :success
  end

  test "should update post" do
    patch api_v1_post_url(@post), params: { post: {} }
    assert_response :success
  end

  test "should destroy post" do
    delete api_v1_post_url(@post)
    assert_response :success
  end
end
