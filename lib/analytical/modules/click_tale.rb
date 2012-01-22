module Analytical
  module Modules
    class ClickTale
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = [:body_prepend, :body_append]
      end

      def init_javascript(location)
        init_location(location) do
          case location.to_sym
            when :body_prepend
              js = <<-HTML
              <!-- Analytical Init: ClickTale Top part -->
              <script type="text/javascript">
              var WRInitTime=(new Date()).getTime();
              </script>
              <!-- ClickTale end of Top part -->
              HTML
              js
            when :body_append
              js = <<-HTML
              <!-- Analytical Init: ClickTale Bottom part -->
          		<div id="ClickTaleDiv" style="display: none;"></div>
          		<script type='text/javascript'>
          		document.write(unescape("%3Cscript%20src='"+
          		 (document.location.protocol=='https:'?
          		  'https://clicktale.pantherssl.com/':
          		  'http://s.clicktale.net/')+
          		 "#{@options[:script_name] || "WRb6"}.js'%20type='text/javascript'%3E%3C/script%3E"));
          		</script>
          		<script type="text/javascript">
          		var ClickTaleSSL=1;
          		if(typeof ClickTale=='function') ClickTale(#{@options[:project_id]},#{@options[:site_traffic]},\"#{@options[:www_param] || 'www'}\");
          		</script>
          		<!-- ClickTale end of Bottom part -->
              HTML
              js
          end
        end
      end

    end
  end
end
