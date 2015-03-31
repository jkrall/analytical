module Analytical
  module Modules
    class SiftScience
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :head_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Sift Science -->
          <script type="text/javascript">
            var _sift = _sift || [];
            _sift.push(['_setAccount', '#{options[:key]}']);

            (function() {
              function ls() {
                var e = document.createElement('script');
                e.type = 'text/javascript';
                e.async = true;
                e.src = ('https:' === document.location.protocol ? 'https://' : 'http://') + 'cdn.siftscience.com/s.js';
                var s = document.getElementsByTagName('script')[0];
                s.parentNode.insertBefore(e, s);
              }
              if (window.attachEvent) {
                window.attachEvent('onload', ls);
              } else {
                window.addEventListener('load', ls, false);
              }
            })();
          </script>
          HTML
          js
        end
      end

      def set(*args)
        <<-JS.gsub(/^ {10}/, '')
          if (properties) {
            _sift.push(['_setUserId', properties.user_id]);
            _sift.push(['_setSessionId', properties.session_id]);
            _sift.push(['_trackPageview']);
          }
        JS
      end
    end
  end
end
