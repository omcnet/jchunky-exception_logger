class LoggedExceptionsController < ApplicationController

  cattr_accessor :application_name
  layout nil

  #ApplicationController.class_eval do
  #  rescue_from Exception, :with => :log_exception_handler
  #end

  def index
    @exception_names    = LoggedException.find_exception_class_names
    @controller_actions = LoggedException.find_exception_controllers_and_actions
    query
  end


  def query
    exceptions = LoggedException.sorted
    unless params[:id].blank?
      exceptions = exceptions.where(:id => params[:id])
    end
    unless params[:query].blank?
      exceptions = exceptions.message_like(params[:query])
    end
    unless params[:date_ranges_filter].blank?
      exceptions = exceptions.days_old(params[:date_ranges_filter])
    end
    unless params[:exception_names_filter].blank?
      exceptions = exceptions.by_exception_class(params[:exception_names_filter])
    end
    unless params[:controller_actions_filter].blank?
      c_a_params = params[:controller_actions_filter].split('/').collect(&:downcase)
      exceptions = exceptions.by_controller(c_a_params.first)
      exceptions = exceptions.by_action(c_a_params.last)
    end
    @exceptions = exceptions.paginate(:per_page => 30, :page => params[:page])

    respond_to do |format|
      format.html { redirect_to :action => 'index' unless action_name == 'index' }
      format.js
      format.xml
    end
  end

  def show
    @exception = LoggedException.find params[:id]
  end

  def destroy
    @exception = LoggedException.find params[:id]
    @exception.destroy
  end

  def destroy_all
    debugger;
    LoggedException.delete_all(:id => params[:ids]) unless params[:ids].blank?
    query
  end

  private
  def access_denied_with_basic_auth
    headers["Status"]           = "Unauthorized"
    headers["WWW-Authenticate"] = %(Basic realm="Web Password")
    render :text => "Could't authenticate you", :status => '401 Unauthorized'
  end

  @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
  # gets BASIC auth info
  def get_auth_data
    auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
    auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
    return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil]
  end
end

