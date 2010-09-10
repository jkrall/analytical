module Analytical
  module KissMetrics
    class Api
      include Analytical::Base::Api

      def initialize(options={})
        super
        @tracking_command_location = :body_prepend
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: KissMetrics -->
          <script type="text/javascript">
            var _kmq = _kmq || [];
            function _kms(u){
              setTimeout(function(){
                var s = document.createElement('script'); var f = document.getElementsByTagName('script')[0]; s.type = 'text/javascript'; s.async = true;
                s.src = u; f.parentNode.insertBefore(s, f);
              }, 1);
            }
            _kms('//i.kissmetrics.com/i.js');_kms('#{options[:js_url_key]}');
          </script>
          <script type="text/javascript">
            _kmq.push(['pageView']);
          </script>
          HTML
          js
        end
      end

      def identify(id, *args)
        data = args.first || {}
        "_kmq.push([\"identify\", \"#{data[:email]}\"]);"
      end

      def event(name, *args)
        data = args.first || {}
        "_kmq.push([\"record\", \"#{name}\", #{data.to_json}]);"
      end

      def set(data)
        return '' if data.blank?
        "_kmq.push([\"set\", #{data.to_json}]);"
      end

      def alias(old_identity, new_identity)
        "_kmq.push([\"alias\", \"#{old_identity}\", \"#{new_identity}\"]);"
      end

    end
  end
end
