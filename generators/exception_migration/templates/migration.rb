class <%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= exception_table_name %>", :force => true do |t|
      t.string :exception_class, :controller_name, :action_name
      t.text :message, :backtrace, :environment, :request
      t.timestamps
    end
    
    [:exception_class, [:controller_name, :action_name], :created_at].each do |column|
      add_index "<%= exception_table_name %>", column
    end
  end

  def self.down
    drop_table "<%= exception_table_name %>"
  end
end
