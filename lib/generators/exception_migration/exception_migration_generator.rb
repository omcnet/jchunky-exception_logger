require 'rails/generators'
require 'rails/generators/migration'

class ExceptionMigrationGenerator < Rails::Generators::Base
  desc "The exception migration generator creates a migration for the logged exceptions model."
  include Rails::Generators::Migration
  source_root File.join(File.dirname(__FILE__), 'templates')

  def initialize(args = [], options = {}, config = {})
    super
  end

  #attr_reader :exception_table_name

  # Implement the required interface for Rails::Generators::Migration.
  # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  def create_migration_file
    migration_template 'migration.rb', 'db/migrate/add_logged_exception_table.rb'
  end

end
