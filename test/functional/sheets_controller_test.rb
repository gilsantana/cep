require 'test_helper'

class SheetsControllerTest < ActionController::TestCase
  setup do
    @sheet = sheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sheet" do
    assert_difference('Sheet.count') do
      post :create, :sheet => @sheet.attributes
    end

    assert_redirected_to sheet_path(assigns(:sheet))
  end

  test "should show sheet" do
    get :show, :id => @sheet.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sheet.to_param
    assert_response :success
  end

  test "should update sheet" do
    put :update, :id => @sheet.to_param, :sheet => @sheet.attributes
    assert_redirected_to sheet_path(assigns(:sheet))
  end

  test "should destroy sheet" do
    assert_difference('Sheet.count', -1) do
      delete :destroy, :id => @sheet.to_param
    end

    assert_redirected_to sheets_path
  end
end
