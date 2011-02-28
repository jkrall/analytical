module Analytical
  module Modules
    class Loopfuse
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: LOOPFUSE TRACKING -->
          <script type="text/javascript">
          var LFHost = (("https:" == document.location.protocol) ? "https://" : "http://");
          document.write(unescape("%3Cscript src='" + LFHost + "lfov.net/webrecorder/js/listen.js' type='text/javascript'%3E%3C/script%3E"));
          </script>
          <script type="text/javascript">
          _lf_cid = "#{options[:cid]}";
          _lf_remora();
          </script>
      		<!-- END: LOOPFUSE TRACKING -->
          HTML
          js
        end
      end
    end
  end
end