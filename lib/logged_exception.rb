class LoggedException < ActiveRecord::Base
  named_scope :by_exception_class, lambda {|exception_class| {:conditions => ["#{LoggedException.quoted_table_name}.exception_class = ?", exception_class]}}
  named_scope :by_controller_and_action, lambda {|controller_name, action_name| {:conditions => ["#{LoggedException.quoted_table_name}.controller_name = ? AND #{LoggedException.quoted_table_name}.action_name = ?", controller_name, action_name]}}
  named_scope :search, lambda {|query| {:conditions => ["#{LoggedException.quoted_table_name}.message LIKE ?", "%#{query}%"]}}
  named_scope :days_old, lambda {|day_number| {:conditions => ["#{LoggedException.quoted_table_name}.created_at >= ?", day_number.to_f.days.ago.utc]}}
  named_scope :sorted, {:order => "#{LoggedException.quoted_table_name}.created_at DESC"}
  
  def name
    "#{self.exception_class} in #{self.controller_action}"
  end
  
  def backtrace=(trace)
    trace = sanitize_backtrace(trace) * "\n" unless trace.is_a?(String)
    write_attribute :backtrace, trace
  end

  def request=(request)
    if request.is_a?(String)
      write_attribute :request, request
    else
      max = request.env.keys.max { |a,b| a.length <=> b.length }
      env = request.env.keys.sort.inject [] do |env, key|
        env << '* ' + ("%-*s: %s" % [max.length, key, request.env[key].to_s.strip])
      end
      write_attribute(:environment, (env << "* Process: #{$$}" << "* Server : #{self.class.host_name}") * "\n")
      
      write_attribute(:request, [
        "* URL:#{" #{request.method.to_s.upcase}" unless request.get?} #{request.protocol}#{request.env["HTTP_HOST"]}#{request.request_uri}",
        "* Format: #{request.format.to_s}",
        "* Parameters: #{request.parameters.inspect}",
        "* Rails Root: #{rails_root}"
      ] * "\n")
    end
  end

  def controller_action
    @controller_action ||= "#{controller_name.camelcase}/#{action_name}"
  end

  def self.class_names
    connection.select_values "SELECT DISTINCT exception_class FROM #{LoggedException.quoted_table_name} ORDER BY exception_class"
  end
  
  def self.controller_actions
    self.all(:select => "DISTINCT controller_name, action_name", :order => "controller_name, action_name").collect(&:controller_action)
  end
  
  def self.create_from_exception(controller, exception, data)
    message = exception.message.inspect
    message << "\n* Extra Data\n\n#{data}" unless data.blank?
    create! \
      :exception_class => exception.class.name,
      :controller_name => controller.controller_name,
      :action_name     => controller.action_name,
      :message         => message,
      :backtrace       => exception.backtrace,
      :request         => controller.request
  end
  
  def self.host_name
    `hostname -s`.chomp
  end
  
  private
    @@rails_root      = Pathname.new(RAILS_ROOT).cleanpath.to_s
    @@backtrace_regex = /^#{Regexp.escape(@@rails_root)}/

    def sanitize_backtrace(trace)
      trace.collect { |line| Pathname.new(line.gsub(@@backtrace_regex, "[RAILS_ROOT]")).cleanpath.to_s }
    end

    def rails_root
      @@rails_root
    end
end