module Analytical
  module Google
    class Api
      include Analytical::Base::Api

      def initialize(options={})
        super
        @tracking_command_location = :head_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Google -->
          <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', '#{options[:key]}'], ['_trackPageview']);
            (function() {
              var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
              ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
              var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
          </script>
          HTML
          js
        end
      end

      def track(*args)
        "_gaq.push(['_trackPageview'#{args.empty? ? ']' : ', "' + args.first + '"]'});"
      end

    end
  end
end