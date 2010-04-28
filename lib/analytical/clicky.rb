module Analytical
  module Clicky

    class Api
      include Analytical::Base::Api

      def track
        puts 'Clicky Track Called'
        super
      end

    end

  end
end