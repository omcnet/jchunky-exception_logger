require "exception_logger"
require "rails"
require "will_paginate"
require "i18n"

module ExceptionLogger
  class Engine < Rails::Engine
    ## Better: TODO create rake task to copy files to application/public
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
    rake_tasks do
      load "exception_logger/railties/tasks.rake"
    end

  end
end
