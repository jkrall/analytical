module Analytical
  module Modules
    class GoogleOptimizer
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :head_prepend
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init:  Google Website Optimizer Control Script -->
      		<script>
      		function utmx_section(){}function utmx(){}
      		(function(){var k='#{options[:key]}',d=document,l=d.location,c=d.cookie;function f(n){
      		if(c){var i=c.indexOf(n+'=');if(i>-1){var j=c.indexOf(';',i);return c.substring(i+n.
      		length+1,j<0?c.length:j)}}}var x=f('__utmx'),xx=f('__utmxx'),h=l.hash;
      		d.write('<sc'+'ript src="'+
      		'http'+(l.protocol=='https:'?'s://ssl':'://www')+'.google-analytics.com'
      		+'/siteopt.js?v=1&utmxkey='+k+'&utmx='+(x?x:'')+'&utmxx='+(xx?xx:'')+'&utmxtime='
      		+new Date().valueOf()+(h?'&utmxhash='+escape(h.substr(1)):'')+
      		'" type="text/javascript" charset="utf-8"></sc'+'ript>')})();
      		</script>
      		<!-- End of Google Website Optimizer Control Script -->
      		<!-- Analytical Init: Google Website Optimizer Tracking Script -->
          <script type="text/javascript">
          if(typeof(_gat)!='object')document.write('<sc'+'ript src="http'+
          (document.location.protocol=='https:'?'s://ssl':'://www')+
          '.google-analytics.com/ga.js"></sc'+'ript>')</script>
          <script type="text/javascript">
          try {
            var gwoTracker=_gat._getTracker("#{options[:account]}");
            gwoTracker._trackPageview("/#{options[:key]}/test");
            }catch(err){}</script>
          <!-- End of Google Website Optimizer Tracking Script -->
          HTML
          js
        end
      end

      def conversion(*args)
        js = <<-HTML
        <!-- Analytical Init:  Google Website Optimizer Conversion Script -->
        <script type="text/javascript">
        if(typeof(_gat)!='object')document.write('<sc'+'ript src="http'+
        (document.location.protocol=='https:'?'s://ssl':'://www')+
        '.google-analytics.com/ga.js"></sc'+'ript>')</script>
        <script type="text/javascript">
        try {
          var gwoTracker=_gat._getTracker("#{options[:account]}");
          gwoTracker._trackPageview("/#{options[:key]}/goal");
          }catch(err){}</script>
        <!-- End of Google Website Optimizer Conversion Script -->
        HTML
        js
      end

    end
  end
end