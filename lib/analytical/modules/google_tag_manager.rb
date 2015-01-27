module Analytical
  module Modules
    class GoogleTagManager
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = {
          init_javascript: [:head_prepend, :body_prepend],
          event: :body_append,
          track: :body_append,
          set: :head_append,
          track_page: :head_append,
          key_interaction: :body_append
        }
      end

      def init_javascript(location)
        dataLayer = [{ ga_id: options[:key]}];

        init_location(location) do
          case location.to_sym
          when :head_prepend
            js = <<-HTML
              <!-- Google Data Layer -->
              <script>var dataLayer = #{dataLayer.to_json};</script>
              <!-- End Google Data Layer -->
            HTML
            js
          when :body_prepend 
            js = <<-HTML
              <!-- Google Tag Manager -->
              <noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-PF3LZL"
              height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
              <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
              new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
              j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
              '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
              })(window,document,'script','dataLayer','GTM-PF3LZL');</script>
              <!-- End Google Tag Manager -->
            HTML
            js
          end
        end
      end

      def track_page(page_name, page_type)
        "dataLayer.push({ 'page_pageName': '#{page_name}', 'page_pageType': '#{page_type}'});"
      end

      def track(*args)
        name = args.first;
        "dataLayer.push({ 'page_virtualName': \"#{name}\", 'event': 'gtm.view' });"
      end

      def event(name, *args)
        params = args.first || {}
        <<-HTML
        var dataLayerEventData = #{params.to_json};
        dataLayerEventData['event'] = "#{name}";
        dataLayer.push(dataLayerEventData);
        HTML
      end

      def key_interaction(name, *args)
        params = args.first || {}
        params.merge({'interactionType' => name});
        self.event('key interaction', params)
      end

      def set(data)
        return '' if data.blank?
        "dataLayer.push(#{data.to_json});"
      end
    end
  end
end

