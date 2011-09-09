require File.dirname(__FILE__)+'/analytical/rails/engine'
require File.dirname(__FILE__)+'/analytical/modules/base'
Dir.glob(File.dirname(__FILE__)+'/analytical/**/*.rb').each do |f|
  require f
end

module Analytical

  def analytical(options={})
    self.analytical_options = options

    config_options = { :modules => [] }
    File.open("#{::Rails.root}/config/analytical.yml") do |f|
      file_options = YAML::load(ERB.new(f.read).result).symbolize_keys
      env = (::Rails.env || :production).to_sym
      file_options = file_options[env] if file_options.has_key?(env)
      file_options.each do |k, v|
        if v.respond_to?(:symbolize_keys)
          # module configuration
          config_options[k.to_sym] = v.symbolize_keys
          config_options[:modules] << k.to_sym unless options && options[:modules]
        else
          # regular option
          config_options[k.to_sym] = v
        end
      end if file_options
    end if File.exists?("#{::Rails.root}/config/analytical.yml")

    self.analytical_options = self.analytical_options.reverse_merge config_options
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
        options[:javascript_helpers] ||= true
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
