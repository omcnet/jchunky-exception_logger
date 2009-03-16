require 'will_paginate' unless Kernel.const_defined? 'WillPaginate'
WillPaginate.enable
ExceptionLoggableControllerMixin.custom_view_paths = [File.join(directory, 'views')]
