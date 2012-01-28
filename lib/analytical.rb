require File.dirname(__FILE__)+'/analytical/rails/engine'
require File.dirname(__FILE__)+'/analytical/modules/base'
Dir.glob(File.dirname(__FILE__)+'/analytical/**/*.rb').each do |f|
  require f
end

module Analytical

  def analytical(options = {})
    config = Analytical.config(options[:config])
    self.analytical_options = options.reverse_merge(config)
  end

  def self.config(path = nil)
    path = Pathname.new(path || ::Rails.root.join("config/analytical.yml"))
    return {} unless path.exist?

    # Only read the config from any given file one time
    @configs ||= {}
    @configs[path] ||= begin
      # Read the config out of the file
      config = YAML.load(path.read).with_indifferent_access

      # Pull out the correct environment (or toplevel if there isn't an env)
      env = ::Rails.env || :production
      config = config[env] if config.has_key?(env)

      # List the modules that were configured
      config = (config || {}).reverse_merge(:modules => [])
      config.each{|k, v| config[:modules] << k.to_sym if v.is_a?(Hash) }
    end
  end

  module InstanceMethods
    def analytical
      @analytical ||= begin
        options = self.class.analytical_options.merge({
          :ssl => request.ssl?,
          :controller => self,
        })
        if options[:disable_if] && options[:disable_if].call(self)
          options[:modules] = []
        end
        options[:session] = session if options[:use_session_store]
        if analytical_is_robot?(request.user_agent)
          options[:modules] = []
        end
        options[:modules] = options[:filter_modules].call(self, options[:modules]) if options[:filter_modules]
        options[:javascript_helpers] ||= true if options[:javascript_helpers].nil?
        Analytical::Api.new options
      end
    end
  end

  module HelperMethods
    def analytical
      controller.analytical
    end
  end

end

if defined?(ActionController::Base)
  ActionController::Base.class_eval do
    extend Analytical
    include Analytical::InstanceMethods
    include Analytical::BotDetector
    helper Analytical::HelperMethods

    if ::Rails::VERSION::MAJOR < 3
      class_inheritable_accessor :analytical_options
    else
      class_attribute :analytical_options
    end
  end
end
