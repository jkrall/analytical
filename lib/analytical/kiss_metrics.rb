module Analytical
  module KissMetrics
    class Api
      include Analytical::Base::Api

      def initialize(parent, options={})
        super
        @tracking_command_location = :body_prepend
      end

      def init_javascript(location)
        return '' unless location==:body_prepend
        js = <<-HTML
        <!-- Analytical Init: KissMetrics -->
        <script type="text/javascript">
          var _kmq = _kmq || [];
          (function(){function _kms(u,d){if(navigator.appName.indexOf("Microsoft")==0 && d)document.write("<scr"+"ipt defer='defer' async='true' src='"+u+"'></scr"+"ipt>");else{var s=document.createElement('script');s.type='text/javascript';s.async=true;s.src=u;(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(s);}}_kms('http' + ('https:' == document.location.protocol ? 's://': '://') + 'i.kissmetrics.com/i.js', 1);_kms('http'+('https:'==document.location.protocol ? 's://s3.amazonaws.com/' : '://')+'scripts.kissmetrics.com/#{options[:key]}.1.js',1);})();
        </script>
        <script type="text/javascript">
          _kmq.push(['pageView']);
        </script>
        HTML
        js
      end

      def identify(id, *args)
        data = args.first || {}
        "_kmq.push([\"identify\", \"#{data[:email]}\"]);"
      end

      def event(name, *args)
        data = args.first || {}
        "_kmq.push([\"record\", \"#{name}\", #{data.to_json}]);"
      end

      def set(data, *args)
        return '' if data.blank?
        "_kmq.push([\"set\", #{data.to_json}]);"
      end

    end
  end
end