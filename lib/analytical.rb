module Analytical

  # any method placed here will apply to ActionController::Base
  def analytical(options={})
    send :include, InstanceMethods
    send :cattr_accessor, :analytical_options

    self.analytical_options = options.reverse_merge({
      :modules=>[],
      :development_modules=>[:console],
      :disable_if=>Proc.new { !Rails.env.production? },
    })

    if self.analytical_options[:disable_if].call
      self.analytical_options[:modules] = self.analytical_options[:development_modules]
    end
    self.analytical_options[:modules].each do |m|
      Analytical::Api.send :include, "Analytical::#{m.to_s.camelize}".constantize
    end
  end

  class Api
    attr_accessor :options, :modules

    def initialize(options={})
      @options = options
      @modules = @options[:modules].inject({}) do |h, m|
        h[m] = "Analytical::#{m.to_s.camelize}::Api".constantize.new(self)
        h
      end
    end
  end

  module InstanceMethods
    # any method placed here will apply to instances


    def analytical
      @analytical ||= Analytical::Api.new self.class.analytical_options
    end
  end

end