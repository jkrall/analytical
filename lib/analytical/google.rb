module Analytical
  module Google

    class Api
      include Analytical::Base::Api

      def track
        puts 'Google Track Called'
        super
      end

    end

  end
end