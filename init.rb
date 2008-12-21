require 'will_paginate' unless Kernel.const_defined? 'WillPaginate'
WillPaginate.enable
LoggedExceptionsController.view_paths = [File.join(directory, 'views')]
LoggedExceptionsMailer.view_paths = File.join(File.dirname(__FILE__), 'views')
