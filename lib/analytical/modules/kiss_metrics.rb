module Analytical
  module Modules
    class KissMetrics
      include Analytical::Modules::Base

      def initialize(options={})
        super
        check_js_url_key
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
          HTML
          js
        end
      end

      def identify(*args) # id, options
        <<-JS.gsub(/^ {10}/, '')
          if (options && options.email) {
            _kmq.push(['identify', options.email]);
          }
        JS
      end

      def event(*args) # name, options, callback
        <<-JS.gsub(/^ {10}/, '')
          _kmq.push(['record', name, options]);
        JS
      end

      def set(*args) # properties
        <<-JS.gsub(/^ {10}/, '')
          if (properties) {
            _kmq.push(['set', properties]);
          }
        JS
      end

      def alias_identity(*args) # old_identity, new_identity
        <<-JS.gsub(/^ {10}/, '')
          _kmq.push(['alias', old_identity, new_identity]);
        JS
      end

    private

      def check_js_url_key
        if options[:js_url_key].nil?
          raise "You didn't provide a js_url_key for kiss_metrics. " +
            "Add one to your analytical.yml file so KissMetrics will work."
        end
      end

    end
  end
end
