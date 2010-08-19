require 'test_helper'

class LoggedExceptionsControllerTest < ActionController::TestCase

  tests LoggedExceptionsController

  context "whitout javascript" do

    context "on GET to #index" do
      setup do
        @exception = Factory(:logged_exception, :id => 123)
        get :index
      end

      should respond_with(:success)
      should render_template(:index)
      should "query all unique exception names" do
        assert_not_nil assigns(:exception_names)
        assert_equal ["FunnyError"], assigns(:exception_names)
      end
      should "query all unique controller and action names" do
        assert_not_nil assigns(:controller_actions)
        assert_equal ["Main/index"], assigns(:controller_actions)
      end
      should "set exceptions variable for view" do
        assert_not_nil assigns(:exceptions)
        assert_equal [@exception], assigns(:exceptions)
      end
      should_render_with_layout :logged_exceptions
      should_not set_the_flash
    end

    context "on GET to #show for exception 123" do
      setup do
        @exception = Factory(:logged_exception, :id => 123)
        get :show, :id => "123"
      end

      should respond_with(:success)
      should render_template(:show)
      should "set exception variable for view" do
        assert_not_nil assigns(:exception)
        assert_equal @exception, assigns(:exception)
      end
      should_render_with_layout :logged_exceptions
      should_not set_the_flash
    end

  end

  context "with javascript" do
    # need tests.
  end

end