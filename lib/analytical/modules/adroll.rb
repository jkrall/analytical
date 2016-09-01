module Analytical
  module Modules
    class Adroll
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Adroll -->
          <script type="text/javascript">
          adroll_adv_id = "#{options[:adv_id]}";
          adroll_pix_id = "#{options[:pix_id]}";
          (function () {
            var _onload = function(){
              if (document.readyState && !/loaded|complete/.test(document.readyState)){setTimeout(_onload, 10);return}
              if (!window.__adroll_loaded){__adroll_loaded=true;setTimeout(_onload, 50);return}
              var scr = document.createElement("script");
              var host = (("https:" == document.location.protocol) ? "https://s.adroll.com" : "http://a.adroll.com");
              scr.setAttribute('async', 'true');
              scr.type = "text/javascript";
              scr.src = host + "/j/roundtrip.js";
              ((document.getElementsByTagName('head') || [null])[0] ||
                  document.getElementsByTagName('script')[0].parentNode).appendChild(scr);
            };
            if (window.addEventListener) {window.addEventListener('load', _onload, false);}
            else {window.attachEvent('onload', _onload)}
          }());
          </script>
          HTML
          js
        end
      end

    end
  end
end
