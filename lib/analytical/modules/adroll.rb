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
          var oldonload = window.onload;
          window.onload = function(){
             __adroll_loaded=true;
             var scr = document.createElement("script");
             var host = (("https:" == document.location.protocol) ? "https://s.adroll.com" : "http://a.adroll.com");
             scr.setAttribute('async', 'true');
             scr.type = "text/javascript";
             scr.src = host + "/j/roundtrip.js";
             document.documentElement.firstChild.appendChild(scr);
             if(oldonload){oldonload()}};
          }());
          </script>
          HTML
          js
        end
      end

    end
  end
end