module Analytical
  module Console
    class Api
      include Analytical::Base::Api
      include ActionView::Helpers::JavaScriptHelper

      def initialize(parent, options={})
        super
        @tracking_command_location = :head
      end

      def init_javascript
        js_blocks = {}
        js_blocks[:head] = <<-HTML
        <!-- Analytical Init: Console -->
        <script type="text/javascript">
          console.log('Analytical Init: Console');
        </script>
        HTML
        js_blocks
      end

      def track(*args)
        "console.log(\"Analytical Track: #{escape_javascript args.to_json}\");"
      end

      def identify(*args)
        "console.log(\"Analytical Identify: #{escape_javascript args.to_json}\");"
      end

    end
  end
end