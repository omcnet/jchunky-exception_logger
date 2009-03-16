class LoggedExceptionsController < ActionController::Base
<<<<<<< HEAD:lib/logged_exceptions_controller.rb
  cattr_accessor :application_name
  layout nil

  def index
    @exception_names    = LoggedException.class_names
    @controller_actions = LoggedException.controller_actions
    query
  end

  def query
    scope = LoggedException
    scope = scope.search(params[:query]) unless params[:query].blank?
    scope = scope.days_old(params[:date_ranges_filter]) unless params[:date_ranges_filter].blank?
    scope = scope.by_exception_class(params[:exception_names_filter]) unless params[:exception_names_filter].blank?
    scope = scope.by_controller_and_action(*params[:controller_actions_filter].split('/').collect(&:downcase)) unless params[:controller_actions_filter].blank?
    scope = scope.sorted
    
    params[:limit] ||= 25
    params[:page] ||= 1
    
    @exceptions = if $PAGINATION_TYPE == 'will_paginate' then
      scope.paginate :per_page => params[:limit], :page => params[:page]
    elsif $PAGINATION_TYPE == 'paginating_find' then
      scope.all :page => {:size => params[:limit], :current => params[:page]}
    else
      #we have no pagination so do basic sql pagination
      params[:page] ||= 0
      page = params[:page]
      page = params[:page].to_i * params[:limit].to_i if params[:page].to_i >= 1
      
      scope.all :limit => "#{page},#{params[:limit]}"
    end
    
    respond_to do |format|
      format.html { redirect_to :action => "index" unless action_name == "index" }
      format.js   { render :action => "query.rjs" }
      format.rss  { render :action => "query.rxml" }
    end
  end
  
  def show
    @exception = LoggedException.find params[:id]
  end
  
  def destroy
    @exception = LoggedException.destroy params[:id]
  end
  
  def destroy_all
    LoggedException.delete_all ['id in (?)', params[:ids]] unless params[:ids].blank?
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
=======
  include ExceptionLoggableControllerMixin
end
>>>>>>> 4828f97a6385637675381a324c07f221074c81ce:lib/logged_exceptions_controller.rb
