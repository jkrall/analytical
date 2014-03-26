module Analytical
  module Modules
    class Mixpanel
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Mixpanel -->
          <script type="text/javascript">
            (function(c,a){window.mixpanel=a;var b,d,h,e;b=c.createElement("script");
            b.type="text/javascript";b.async=!0;b.src=("https:"===c.location.protocol?"https:":"http:")+
            '//cdn.mxpnl.com/libs/mixpanel-2.2.min.js';d=c.getElementsByTagName("script")[0];
            d.parentNode.insertBefore(b,d);a._i=[];a.init=function(b,c,f){function d(a,b){
            var c=b.split(".");2==c.length&&(a=a[c[0]],b=c[1]);a[b]=function(){a.push([b].concat(
            Array.prototype.slice.call(arguments,0)))}}var g=a;"undefined"!==typeof f?g=a[f]=[]:
            f="mixpanel";g.people=g.people||[];h=['disable','track','track_pageview','track_links',
            'track_forms','register','register_once','unregister','identify','alias','name_tag','set_config',
            'people.set','people.set_once','people.increment','people.track_charge','people.append'];
            for(e=0;e<h.length;e++)d(g,h[e]);a._i.push([b,c,f])};a.__SV=1.2;})(document,window.mixpanel||[]);
            mixpanel.init('#{options[:key]}');
          </script>
          HTML
          js
        end
      end

      def identify(*args) # id, options
        <<-JS.gsub(/^ {10}/, '')
          if (options) {
            mixpanel.people.set(options);
            if (options.name) {
              mixpanel.name_tag(options.name);
            }
          }
          mixpanel.identify(id);
        JS
      end

      def event(*args) # name, options, callback
        <<-JS.gsub(/^ {10}/, '')
          mixpanel.track(name, options || {});
        JS
      end

      # def track(*args) # event, properties, callback
      #   # event_name, properties, callback
      #   <<-JS.gsub(/^ {10}/, '')
      #     mixpanel.track(event, properties, callback);
      #   JS
      # end

      # Used to set "Super Properties" - http://mixpanel.com/api/docs/guides/super-properties
      def set(*args) # properties
        <<-JS.gsub(/^ {10}/, '')
          mixpanel.register(properties);
        JS
      end

    end
  end
end
