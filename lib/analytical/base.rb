module Analytical
  module Base
    module Api
      attr_reader :tracking_command_location

      def initialize(parent)
        @parent = parent
        @tracking_command_location = :body_prepend
      end

      def track
        p 'Track Called'
      end

      def init_javascript; {}; end
    end
  end
end