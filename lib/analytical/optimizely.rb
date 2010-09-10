module Analytical
  module Optimizely
    class Api
      include Analytical::Base::Api

      def initialize(options={})
        super
        @tracking_command_location = :head_prepend
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Optimizely -->
          <script type="text/javascript">document.write(unescape("%3Cscript src='"+document.location.protocol+"//cdn.optimizely.com/js/#{options[:key]}.js' type='text/javascript'%3E%3C/script%3E"));</script>
          HTML
          js
        end
      end

    end
  end
end