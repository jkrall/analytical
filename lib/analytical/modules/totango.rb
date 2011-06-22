module Analytical
  module Modules
    class Totango
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_prepend
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Totango -->
          <!-- step 1: include the loader script -->
          <script src='//s3.amazonaws.com/totango-cdn/sdr.js'></script>

          <!-- step 2: initialize tracking  -->
          <script type="text/javascript">
          try {
          	var serviceId = #{options[:key]};
          	var tracker = new __sdr(\"serviceId\");
          } catch (err) {
          	// uncomment the alert below for debugging only
          	alert ("Totango tracking code load failure, tracking will be ignored");
          	quite = function () {};
          	var tracker = {
          		track: quite,
          		identify: quite
          	};
          }
          </script>
          HTML
          js
        end
      end

      def identify(id, *args)
        data = args.first || {}
        "tracker.identify(\"#{data[:email]}\",\"#{data[:organization]}\");"
      end

      def event(name, *args)
        data = args.first || {}
        "tracker.track(\"#{name}\", \"#{data[:module]}\");"
      end

    end
  end
end
