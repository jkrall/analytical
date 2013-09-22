module Analytical
  module Modules
    class Mouseflow
      include Analytical::Modules::Base

      def initialize(options={})
        super
        check_js_url
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Mouseflow -->
          <script type="text/javascript">
             var _mfq = _mfq || [];
             (function() {
                 var mf = document.createElement("script"); mf.type = "text/javascript"; mf.async = true;
                 mf.src = "#{options[:js_url]}";
                 document.getElementsByTagName("head")[0].appendChild(mf);
             })();
          </script>
          HTML
          js
        end
      end

    private

      def check_js_url
        if options[:js_url].nil?
          raise "You didn't provide a js_url for mouseflow. " +
            "Add one to your analytical.yml file so Mouseflow will work."
        end
      end

    end
  end
end