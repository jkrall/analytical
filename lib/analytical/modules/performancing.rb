module Analytical
  module Modules
    class Performancing
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Performancing Metrics -->
      		<script type="text/javascript">
      		var clicky = { log: function(){ return; }, goal: function(){ return; }};
      		var clicky_site_id = #{options[:site_id]};
      		(function() {
      		  var s = document.createElement('script');
      		  s.type = 'text/javascript';
      		  s.async = true;
      		  s.src = ( document.location.protocol == 'https:' ? 'https://pmetrics.performancing.com' : 'http://pmetrics.performancing.com' ) + '/js';
      		  ( document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0] ).appendChild( s );
      		})();
      		</script>
      	  <!-- End Performancing Metrics -->
          HTML
          js
        end
      end

    end
  end
end