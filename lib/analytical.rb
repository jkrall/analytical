require File.dirname(__FILE__)+'/analytical/modules/base'
Dir.glob(File.dirname(__FILE__)+'/analytical/**/*.rb').each do |f|
  require f
end

module Analytical

  # any method placed here will apply to ActionController::Base
  def analytical(options={})
    send :include, InstanceMethods
    send :include, Analytical::BotDetector
    helper_method :analytical
    class_inheritable_accessor :analytical_options

    self.analytical_options = options

    config_options = { :modules => [] }
    File.open("#{Rails.root}/config/analytical.yml") do |f|
      file_options = YAML::load(ERB.new(f.read).result).symbolize_keys
      env = (Rails.env || :production).to_sym
      file_options = file_options[env] if file_options.has_key?(env)
      file_options.each do |k, v|
        config_options[k.to_sym] = v.symbolize_keys
        config_options[:modules] << k.to_sym unless options && options[:modules]
      end if file_options
    end if File.exists?("#{Rails.root}/config/analytical.yml")

    self.analytical_options = self.analytical_options.reverse_merge config_options
  end

  module InstanceMethods
    # any method placed here will apply to instances

    def analytical
      @analytical ||= begin
        options = self.class.analytical_options.merge({
          :ssl => request.ssl?
        })
        if options[:disable_if] && options[:disable_if].call(self)
          options[:modules] = []
        end
        options[:session] = session if options[:use_session_store]
        if analytical_is_robot?(request.user_agent)
          options[:modules] = []
        end
        Analytical::Api.new options
      end
    end
  end

end

if defined?(ActionController::Base)
  ActionController::Base.extend Analytical
end
