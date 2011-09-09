module Analytical
  module Modules
    class DummyModule
      include Analytical::Modules::Base
      def method_missing(method, *args, &block); nil; end
    end
  end

  class Api
    attr_accessor :options, :modules

    def initialize(options={})
      @options = options
      @modules = @options[:modules].inject(ActiveSupport::OrderedHash.new) do |h, m|
        module_options = @options.merge(@options[m] || {})
        module_options.delete(:modules)
        module_options[:session_store] = Analytical::SessionCommandStore.new(@options[:session], m) if @options[:session]
        h[m] = "Analytical::Modules::#{m.to_s.camelize}".constantize.new(module_options)
        h
      end
      @dummy_module = Analytical::Modules::DummyModule.new
    end

    #
    # Catch commands such as :track, :identify and send them on to all of the modules.
    # Or... if a module name is passed, return that module so it can be used directly, ie:
    # analytical.console.go 'make', :some=>:cookies
    #
    def method_missing(method, *args, &block)
      method = method.to_sym
      if @modules.keys.include?(method)
        @modules[method]
      elsif available_modules.include?(method)
        @dummy_module
      else
        process_command method, *args
      end
    end


    #
    # Delegation class that passes methods to
    #
    class ImmediateDelegateHelper
      def initialize(_parent)
        @parent = _parent
      end
      def method_missing(method, *args, &block)
        @parent.modules.values.collect do |m|
          m.send(method, *args) if m.respond_to?(method)
        end.delete_if{|c| c.blank?}.join("\n")
      end
    end

    #
    # Returns a new delegation object for immediate processing of a command
    #
    def now
      ImmediateDelegateHelper.new(self)
    end

    #
    # These methods return the javascript that should be inserted into each section of your layout
    #
    def head_prepend_javascript
      [init_javascript(:head_prepend), tracking_javascript(:head_prepend)].delete_if{|s| s.blank?}.join("\n")
    end

    def head_append_javascript
      js = [
        init_javascript(:head_append),
        tracking_javascript(:head_append),
      ]

      if options[:javascript_helpers]
        if ::Rails::VERSION::MAJOR >= 3 && ::Rails::VERSION::MINOR >= 1  # Rails 3.1 lets us override views in engines
          js << options[:controller].send(:render_to_string, :partial=>'analytical_javascript') if options[:controller]
        else # All other rails
          _partial_path = Pathname.new(__FILE__).dirname.join('..', '..', 'app/views/application', '_analytical_javascript.html.erb').to_s
          js << options[:controller].send(:render_to_string, :partial=>_partial_path) if options[:controller]
        end
      end

      js.delete_if{|s| s.blank?}.join("\n")
    end

    alias_method :head_javascript, :head_append_javascript

    def body_prepend_javascript
      [init_javascript(:body_prepend), tracking_javascript(:body_prepend)].delete_if{|s| s.blank?}.join("\n")
    end
    def body_append_javascript
      [init_javascript(:body_append), tracking_javascript(:body_append)].delete_if{|s| s.blank?}.join("\n")
    end

    private

    def process_command(command, *args)
      @modules.values.each do |m|
        m.queue command, *args
      end
    end

    def tracking_javascript(location)
      commands = []
      @modules.each do |name, m|
        commands += m.process_queued_commands if m.init_location?(location) || m.initialized
      end
      commands = commands.delete_if{|c| c.blank? || c.empty?}
      unless commands.empty?
        commands.unshift "<script type='text/javascript'>"
        commands << "</script>"
      end
      commands.join("\n")
    end

    def init_javascript(location)
      @modules.values.collect do |m|
        m.init_javascript(location) if m.respond_to?(:init_javascript)
      end.delete_if{|c| c.blank?}.join
    end

    def available_modules
      Dir.glob(File.dirname(__FILE__)+'/modules/*.rb').collect do |f|
        File.basename(f).sub(/.rb/,'').to_sym
      end - [:base]
    end

  end

end
