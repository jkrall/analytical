module Analytical
  module Modules
    class Mixpanel
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      # Mixpanel-specific queueing behavior, overrides Base#queue
      def queue(*args)
        return if @options[:ignore_duplicates] && @command_store.include?(args)
        if args.first==:alias_identity
          @command_store.unshift args
        elsif args.first==:identify
          if @command_store.empty?
            @command_store.unshift args
          else
            first_command = @command_store.first
            first_command = first_command.first if first_command.respond_to?(:first)
            @command_store.unshift args unless first_command == :alias_identity
          end
        else
          @command_store << args
        end
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
            'track_forms','register','register_once','unregister','identify','alias','name_tag',
            'set_config','people.set','people.increment','people.track_charge','people.append'];
            for(e=0;e<h.length;e++)d(g,h[e]);a._i.push([b,c,f])};a.__SV=1.2;})(document,window.mixpanel||[]);
            var config = { track_pageview: #{options.fetch(:track_pageview, true)} };
            mixpanel.init("#{options[:key]}", config);
          </script>
          HTML
          js
        end
      end

      
      # Examples:
      #     analytical.track(url_viewed)
      #     analytical.track(url_viewed, 'page name' => @page_title)
      #     analytical.track(url_viewed, :event => 'pageview')
      #
      # By default, this module tracks all pageviews under a single Mixpanel event
      # named 'page viewed'. This follows a recommendation in the Mixpanel docs for
      # minimizing the number of distinct events you log, thus keeping your event data uncluttered.
      #
      # The url is followed by a Hash parameter that contains any other custom properties 
      # you want logged along with the pageview event. The following Hash keys get special treatment:
      # * :callback => String representing javascript function to callback
      # * :event => overrides the default event name for pageviews
      # * :url => gets assigned the url you pass in
      #
      # Mixpanel docs also recommend specifying a 'page name' property when tracking pageviews.
      #
      # To turn off pageview tracking for Mixpanel entirely, initialize analytical as follows: 
      #        analytical( ... mixpanel: { key: ENV['MIXPANEL_KEY'], track_pageview: false } ... )
      def track(*args)
        return if args.empty?
        url = args.first
        properties = args.extract_options!
        callback = properties.delete(:callback) || "function(){}"
        event = properties.delete(:event) || 'page viewed'
        if options[:track_pageview] != false
          properties[:url] = url
          # Docs recommend: mixpanel.track('page viewed', {'page name' : document.title, 'url' : window.location.pathname});
          %(mixpanel.track("#{event}", #{properties.to_json}, #{callback});)
        end          
      end

      # Used to set "Super Properties" - http://mixpanel.com/api/docs/guides/super-properties
      def set(properties)
        "mixpanel.register(#{properties.to_json});"
      end

      def identify(id, *args)
        opts = args.first || {}
        name = opts.is_a?(Hash) ? opts[:name] : ""
        name_str = name.blank? ? "" : " mixpanel.name_tag('#{name}');"
        %(mixpanel.identify('#{id}');#{name_str})
      end

      # See https://mixpanel.com/docs/integration-libraries/using-mixpanel-alias
      # For consistency with KissMetrics this method accepts two parameters.
      # However, the first parameter is ignored because Mixpanel doesn't need it;
      # pass any value for the first parameter, e.g. nil.
      def alias_identity(_, new_identity)
        %(mixpanel.alias("#{new_identity}");)
      end

      def event(name, attributes = {})
        %(mixpanel.track("#{name}", #{attributes.to_json});)
      end
      
      def person(attributes = {})
        %(mixpanel.people.set(#{attributes.to_json});)
      end
      
      def revenue(charge, attributes = {})
        %(mixpanel.people.track_charge(#{charge}, #{attributes.to_json});)
      end

    end
  end
end
