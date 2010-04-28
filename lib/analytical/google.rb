module Analytical
  module Google
    class Api
      include Analytical::Base::Api

      def initialize(parent, options={})
        super
        @tracking_command_location = :body_prepend
      end

      def init_javascript
        js_blocks = {}
        js_blocks[:body_prepend] = <<-HTML
        <!-- Analytical Init: Google -->
        <script type="text/javascript">
          var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
          document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
        </script>
        <script type="text/javascript">
          var googleAnalyticsTracker = _gat._getTracker("#{options[:key]}");
          googleAnalyticsTracker._initData();
          pageTracker._trackPageview();
        </script>
        HTML
        js_blocks
      end

      def track(*args)
        "googleAnalyticsTracker._trackPageview('#{args.first}');"
      end

    end
  end
end