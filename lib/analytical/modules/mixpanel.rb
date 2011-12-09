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
          <script type="text/javascript" src="https://api.mixpanel.com/site_media/js/api/mixpanel.js"></script>
          <script type="text/javascript">
              try {
                  var mpmetrics = new MixpanelLib('#{options[:key]}');
              } catch(err) {
                  null_fn = function () {};
                  var mpmetrics = { track: null_fn, track_funnel: null_fn, register: null_fn, register_once: null_fn };
              }
          </script>
          HTML
          js
        end
      end

      def track(event, properties = {})
        callback = properties.delete(:callback) || "function(){}"
        %(mpmetrics.track("#{event}", #{properties.to_json}, #{callback});)
      end
      
      # Used to set "Super Properties" - http://mixpanel.com/api/docs/guides/super-properties
      def set(properties)
        "mpmetrics.register(#{properties.to_json});"
      end

      def identify(id, *args)
        opts = args.first || {}
        name = opts.is_a?(Hash) ? opts[:name] : ""
        name_str = name.blank? ? "" : " mpmetrics.name_tag('#{name}');"
        %(mpmetrics.identify('#{id}');#{name_str})
      end

      def name_tag(name)
        "mpmetrics.name_tag('#{name}');"
      end
      
      def event(name, attributes = {})
        %(mpmetrics.track("#{name}", #{attributes.to_json});)
      end

    end
  end
end
