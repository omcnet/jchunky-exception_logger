class LoggedExceptionsController < ActionController::Base
  include ExceptionLoggableControllerMixin
end