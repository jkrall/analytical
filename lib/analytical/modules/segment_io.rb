module Analytical
  module Modules
    class SegmentIo
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :head_prepend
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Segment.io -->
          <script type="text/javascript">
            window.analytics=window.analytics||[];window.analytics.load=function(apiKey){var script=document.createElement('script');script.type='text/javascript';script.async=true;script.src=('https:'===document.location.protocol?'https://':'http://')+'d2dq2ahtl5zl1z.cloudfront.net/analytics.js/v1/'+apiKey+'/analytics.min.js';var firstScript=document.getElementsByTagName('script')[0];firstScript.parentNode.insertBefore(script,firstScript);var methodFactory=function(type){return function(){window.analytics.push([type].concat(Array.prototype.slice.call(arguments,0)))}};var methods=['identify','track','trackLink','trackForm','trackClick','trackSubmit','pageview','ab','alias','ready'];for(var i=0;i<methods.length;i++){window.analytics[methods[i]]=methodFactory(methods[i])}};window.analytics.load('#{options[:key]}');
          </script>
          HTML
          js
        end
      end

      def track(*args)
        if args.any?
          %(window.analytics.pageview("#{args.first}");)
        else
          %(window.analytics.pageview();)
        end
      end

      def identify(id, attributes = {})
        %(window.analytics.identify("#{id}", #{attributes.to_json});)
      end

      def event(name, attributes = {})
        %(window.analytics.track("#{name}", #{attributes.to_json});)
      end

    end
  end
end
