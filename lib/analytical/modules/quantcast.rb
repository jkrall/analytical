module Analytical
  module Modules
    class Quantcast
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = [:head_append, :body_append]
      end

      def init_javascript(location)
        init_location(location) do
          case location.to_sym
            when :head_append
            js = <<-HTML
            <!-- Analytical Head Init: Quantcast -->
            <script type="text/javascript">
              var _qevents = _qevents || [];

              (function() {
               var elem = document.createElement('script');

               elem.src = (document.location.protocol == "https:" ? "https://secure" : "http://edge") + ".quantserve.com/quant.js";
               elem.async = true;
               elem.type = "text/javascript";
               var scpt = document.getElementsByTagName('script')[0];
               scpt.parentNode.insertBefore(elem, scpt);
              })();
            </script>
            HTML
            js
            when :body_append
            js = <<-HTML
            <!-- Analytical Body Init: Quantcast -->
            <script type="text/javascript">
              _qevents.push( { qacct:"#{options[:key]}"} );
              </script>
              <noscript>
              <div style="display: none;"><img src="//pixel.quantserve.com/pixel/#{options[:key]}.gif" height="1" width="1" alt="Quantcast"/></div>
              </noscript>
            HTML
            js
            end
        end
      end

    end
  end
end