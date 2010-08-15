class LoggedExceptionsController < ActionController::Base
  include ExceptionLoggableControllerMixin
  self.application_name = "My Application Name"
end
