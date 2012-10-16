module Analytical
  module Modules
    class CrazyEgg
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          code_url = "#{options[:key].to_s[0,4]}/#{options[:key].to_s[4,4]}"
          js = <<-HTML
          <!-- Analytical Init: CrazyEgg -->
          <script type="text/javascript">
          setTimeout(function(){var a=document.createElement("script");
          var b=document.getElementsByTagName("script")[0];
          a.src="//dnn506yrbagrg.cloudfront.net/pages/scripts/#{code_url}.js?"+Math.floor(new Date().getTime()/3600000);
          a.async=true;a.type="text/javascript";b.parentNode.insertBefore(a,b)}, 1);
          </script>
          HTML
          js
        end
      end

    end
  end
end