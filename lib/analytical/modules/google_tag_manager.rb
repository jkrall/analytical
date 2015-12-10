module Analytical
  module Modules
    class GoogleTagManager
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_prepend
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML.gsub(/^ {10}/, '')
          <!-- Google Tag Manager -->
          <noscript><iframe src="//www.googletagmanager.com/ns.html?id=#{options[:key]}"
          height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
          <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
          new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
          j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
          '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
          })(window,document,'script','gtmDataLayer','#{options[:key]}');</script>
          <!-- End Google Tag Manager -->
          HTML
          js
        end
      end

      def event(*args) # name, options, callback
        <<-JS.gsub(/^ {10}/, '')
          var gtmVariables = {};
          for (var k in options) {
            gtmVariables[k] = options[k];
          }
          gtmVariables.event = name;
          gtmDataLayer.push(gtmVariables);
        JS
      end
    end
  end
end
