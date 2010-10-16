require 'test_helper'

class ControlsControllerTest < ActionController::TestCase
  setup do
    @control = controls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:controls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create control" do
    assert_difference('Control.count') do
      post :create, :control => @control.attributes
    end

    assert_redirected_to control_path(assigns(:control))
  end

  test "should show control" do
    get :show, :id => @control.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @control.to_param
    assert_response :success
  end

  test "should update control" do
    put :update, :id => @control.to_param, :control => @control.attributes
    assert_redirected_to control_path(assigns(:control))
  end

  test "should destroy control" do
    assert_difference('Control.count', -1) do
      delete :destroy, :id => @control.to_param
    end

    assert_redirected_to controls_path
  end
end
