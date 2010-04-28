module Analytical
  module Console

    class Api
      include Analytical::Base::Api

      def track
        puts 'Console Track Called'
        super
      end

    end

  end
end