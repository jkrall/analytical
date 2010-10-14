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
          <script type="text/javascript" src="http://api.mixpanel.com/site_media/js/api/mixpanel.js"></script>
          <script type="text/javascript">
              try {
                  var mix = new MixpanelLib('#{options[:key]}');
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
        callback = properties.delete(:callback) || "function(){};"
        "mpmetrics.track('#{event}', #{properties.to_json}, #{callback});"
      end

      def identify(id, *args)
        "mpmetrics.identify('#{id}');"
      end

      def event(funnel, *args)
        data = args.last || {}
        step = data.delete(:step)
        goal = data.delete(:goal)
        callback = data.delete(:callback) || "function(){};"
        return "/* API Error: Funnel is not set for 'mpmetrics.track_funnel(funnel:string, step:int, goal:string, properties:object, callback:function); */" if funnel.blank?
        return "/* API Error: Step is not set for 'mpmetrics.track_funnel(#{funnel}, ...); */" unless step && step.to_i >= 0
        return "/* API Error: Goal is not set for 'mpmetrics.track_funnel(#{funnel}, #{step}, ...); */" if goal.blank?
        "mpmetrics.track_funnel('#{funnel}', '#{step}', '#{goal}', #{data.to_json}, #{callback});"
      end

    end
  end
end