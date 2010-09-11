module Analytical
  module Modules
    class Chartbeat
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = [:head_prepend, :body_append]
      end

      def init_javascript(location)
        init_location(location) do
          case location.to_sym
            when :head_prepend
            js = <<-HTML
            <!-- Analytical Head Init: Chartbeat -->
            <script type="text/javascript">var _sf_startpt=(new Date()).getTime();</script>
            HTML
            js
            when :body_append
            js = <<-HTML
            <!-- Analytical Body Init: Chartbeat -->
            <script type="text/javascript">
              var _sf_async_config={uid:#{options[:key]}, domain:"#{options[:domain]}"};
              (function(){
                function loadChartbeat() {
                  window._sf_endpt=(new Date()).getTime();
                  var e = document.createElement('script');
                  e.setAttribute('language', 'javascript');
                  e.setAttribute('type', 'text/javascript');
                  e.setAttribute('src',
                     (("https:" == document.location.protocol) ? "https://s3.amazonaws.com/" : "http://") +
                     "static.chartbeat.com/js/chartbeat.js");
                  document.body.appendChild(e);
                }
                var oldonload = window.onload;
                window.onload = (typeof window.onload != 'function') ?
                   loadChartbeat : function() { oldonload(); loadChartbeat(); };
              })();
              </script>
            HTML
            js
            end
        end
      end

    end
  end
end