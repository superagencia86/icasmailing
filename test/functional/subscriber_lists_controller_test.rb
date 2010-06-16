require 'test_helper'

class SubscriberListsControllerTest < ActionController::TestCase
  
  test 'create' do
    SubscriberList.any_instance.expects(:save).returns(true)
    @resource = subscriber_lists(:basic)
    post :create, :resource => @resource.attributes
    assert_response :redirect
  end
  
  test 'create with failure' do
    SubscriberList.any_instance.expects(:save).returns(false)
    @resource = subscriber_lists(:basic)
    post :create, :resource => @resource.attributes
    assert_template 'new'
  end
  
  test 'update' do
    SubscriberList.any_instance.expects(:save).returns(true)
    @resource = subscriber_lists(:basic)
    put :update, :id => subscriber_lists(:basic).to_param, :resource => @resource.attributes
    assert_response :redirect
  end
  
  test 'update with failure' do
    SubscriberList.any_instance.expects(:save).returns(false)
    @resource = subscriber_lists(:basic)
    put :update, :id => subscriber_lists(:basic).to_param, :resource => @resource.attributes
    assert_template 'edit'
  end
  
  test 'destroy' do
    SubscriberList.any_instance.expects(:destroy).returns(true)
    @resource = subscriber_lists(:basic)
    delete :destroy, :id => @resource.to_param
    assert_not_nil flash[:notice] 
    assert_response :redirect
  end
  
  # Not possible: destroy with failure
  
  test 'new' do
    get :new
    assert_response :success
  end
  
  test 'edit' do
    @resource = subscriber_lists(:basic)
    get :edit, :id => @resource.to_param
    assert_response :success
  end
  
  test 'show' do
    @resource = subscriber_lists(:basic)
    get :show, :id => @resource.to_param
    assert_response :success
  end
  
  test 'index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:subscriber_lists)
  end
  
end