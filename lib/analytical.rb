require File.dirname(__FILE__)+'/analytical/base'
Dir.glob(File.dirname(__FILE__)+'/analytical/*.rb').each do |f|
  require f
end

module Analytical

  # any method placed here will apply to ActionController::Base
  def analytical(options={})
    send :include, InstanceMethods
    send :include, Analytical::BotDetector
    helper_method :analytical
    class_inheritable_accessor :analytical_options

    self.analytical_options = options.reverse_merge({
      :modules=>[],
      :development_modules=>[:console],
      :disable_if=>Proc.new { !Rails.env.production? },
    })

    config_options = {}
    File.open("#{Rails.root}/config/analytical.yml") do |f|
      config_options = YAML::load(ERB.new(f.read).result).symbolize_keys
      config_options.each do |k,v|
        config_options[k] = v.symbolize_keys
      end
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
        if options[:disable_if].call(self)
          options[:modules] = options[:development_modules]
        end
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
