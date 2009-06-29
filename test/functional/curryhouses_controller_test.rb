require 'test_helper'

class CurryhousesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:curryhouses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create curryhouse" do
    assert_difference('Curryhouse.count') do
      post :create, :curryhouse => { }
    end

    assert_redirected_to curryhouse_path(assigns(:curryhouse))
  end

  test "should show curryhouse" do
    get :show, :id => curryhouses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => curryhouses(:one).to_param
    assert_response :success
  end

  test "should update curryhouse" do
    put :update, :id => curryhouses(:one).to_param, :curryhouse => { }
    assert_redirected_to curryhouse_path(assigns(:curryhouse))
  end

  test "should destroy curryhouse" do
    assert_difference('Curryhouse.count', -1) do
      delete :destroy, :id => curryhouses(:one).to_param
    end

    assert_redirected_to curryhouses_path
  end
end
