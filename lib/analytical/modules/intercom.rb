module Analytical
  module Modules
    class Intercom
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      # Intercom identification is being done through the intercom-rails gem

      def event(*args) # name, options, callback
        <<-JS.gsub(/^ {10}/, '')
          Intercom('trackEvent', name, options || {});
        JS
      end
    end
  end
end
