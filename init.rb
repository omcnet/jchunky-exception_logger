require 'will_paginate' unless Kernel.const_defined? 'WillPaginate'
WillPaginate.enable
d = File.dirname(__FILE__)
LoggedExceptionsController.view_paths = [File.join(d, 'views')]
LoggedExceptionsMailer.template_root= File.join(d, 'views')
ExceptionLoggableControllerMixin.custom_view_paths = [File.join(d, 'views')]
