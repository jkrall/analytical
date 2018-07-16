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
          <!-- start Mixpanel --><script type="text/javascript">(function(e,a){if(!a.__SV){var b=window;try{var c,l,i,j=b.location,g=j.hash;c=function(a,b){return(l=a.match(RegExp(b+"=([^&]*)")))?l[1]:null};g&&c(g,"state")&&(i=JSON.parse(decodeURIComponent(c(g,"state"))),"mpeditor"===i.action&&(b.sessionStorage.setItem("_mpcehash",g),history.replaceState(i.desiredHash||"",e.title,j.pathname+j.search)))}catch(m){}var k,h;window.mixpanel=a;a._i=[];a.init=function(b,c,f){function e(b,a){var c=a.split(".");2==c.length&&(b=b[c[0]],a=c[1]);b[a]=function(){b.push([a].concat(Array.prototype.slice.call(arguments,
          0)))}}var d=a;"undefined"!==typeof f?d=a[f]=[]:f="mixpanel";d.people=d.people||[];d.toString=function(b){var a="mixpanel";"mixpanel"!==f&&(a+="."+f);b||(a+=" (stub)");return a};d.people.toString=function(){return d.toString(1)+".people (stub)"};k="disable time_event track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config reset people.set people.set_once people.increment people.append people.union people.track_charge people.clear_charges people.delete_user".split(" ");
          for(h=0;h<k.length;h++)e(d,k[h]);a._i.push([b,c,f])};a.__SV=1.2;b=e.createElement("script");b.type="text/javascript";b.async=!0;b.src="undefined"!==typeof MIXPANEL_CUSTOM_LIB_URL?MIXPANEL_CUSTOM_LIB_URL:"file:"===e.location.protocol&&"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js".match(/^\\/\\//)?"https://cdn.mxpnl.com/libs/mixpanel-2-latest.min.js":"//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js";c=e.getElementsByTagName("script")[0];c.parentNode.insertBefore(b,c)}})(document,window.mixpanel||[]);
          var mixpanel_tracking_opt = {}; var mixpanel_opt_in = true; if ((document.cookie.replace(/(?:(?:^|.*;\s*)performance_cookie\s*\=\s*([^;]*).*$)|^.*$/, "$1") != "true") && (document.cookie.indexOf("performance_cookie") != -1)) { mixpanel_tracking_opt = {opt_out_tracking_by_default: true}; mixpanel_opt_in = false; }
          mixpanel.init('#{options[:key]}', mixpanel_tracking_opt); if(mixpanel_opt_in){ mixpanel.opt_in_tracking(); }</script><!-- end Mixpanel -->
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

      # See https://mixpanel.com/docs/integration-libraries/using-mixpanel-alias
      # For consistency with KissMetrics this method accepts two parameters.
      # However, the first parameter is ignored because Mixpanel doesn't need it;
      # pass any value for the first parameter, e.g. nil.
      def alias_identity(*args) # old_identity, new_identity
        <<-JS.gsub(/^ {10}/, '')
          mixpanel.alias(new_identity);
        JS
      end

      def event(*args) # name, options, callback
        <<-JS.gsub(/^ {10}/, '')
          mixpanel.track(name, options || {});
        JS
      end

      # Used to set "Super Properties" - http://mixpanel.com/api/docs/guides/super-properties
      def set(*args) # properties
        <<-JS.gsub(/^ {10}/, '')
          mixpanel.register(properties);
        JS
      end

      # Clears super properties and generates a new random distinct_id for this instance
      # https://mixpanel.com/help/reference/javascript-full-api-reference#mixpanel.reset
      def reset
        <<-JS.gsub(/^ {10}/, '')
          mixpanel.reset();
        JS
      end
    end
  end
end
