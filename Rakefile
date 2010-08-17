require 'rubygems'
require 'rake'
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "exception_logger"
    gem.summary = "Exception Logger for Rails 3"
    gem.description = "Logs exceptions inside a database table. Now available as gem for Rails3 (previously a plugin for Rails2)"
    gem.email = "roland.guem@gmail.com"
    gem.homepage = "http://github.com/QuBiT/exception_logger"
    gem.authors = ["Roland Guem"]
    gem.files = Dir["{lib}/**/*", "{app}/**/*", "{config}/**/*", "{public}/**/*"]
    gem.add_dependency 'rails', '>=3.0.0.rc'
    gem.add_dependency "will_paginate", ">= 3.0.pre2"
    gem.add_dependency "meta_where", ">= 0.5.2"
    gem.add_dependency "i18n", ">= 0.4.1"
    gem.extra_rdoc_files = ["LICENSE","README.rdoc"]
    gem.post_install_message = %q{
_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_
    Thank you for installing exception_logger.
    Please be sure to read the README and HISTORY on
        http://github.com/QuBiT/exception_logger
    for important information about this release. Happy logging!
_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_()_
    }
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ExceptionLoggerV3 #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
