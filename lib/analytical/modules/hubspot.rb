module Analytical
  module Modules
    class Hubspot
      include Analytical::Modules::Base

      def initialize(options={})
        super
        check_hub_id
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Hubspot -->
          <script type="text/javascript">
            (function(d,s,i,r) {
              if (d.getElementById(i)){return;}
              var n=d.createElement(s),e=d.getElementsByTagName(s)[0];
              n.id=i;n.src='//js.hubspot.com/analytics/'+(Math.ceil(new Date()/r)*r)+'/#{options[:hub_id]}.js';
              e.parentNode.insertBefore(n, e);
            })(document,"script","hs-analytics",300000);
          </script>
          HTML
          js
        end
      end

      private

      def check_hub_id
        if options[:hub_id].nil?
          raise ArgumentError, "Hubspot tracking requires 'hub_id' to be set in the 'analytical.yml' config file; " +
            "'portal_id' and 'domain' are no longer used."
        end
      end

    end
  end
end
