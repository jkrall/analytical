module Analytical
  module Console
    class Api
      include Analytical::Base::Api
      include ActionView::Helpers::JavaScriptHelper

      def initialize(parent, options={})
        super
        @tracking_command_location = :head
      end

      def init_javascript(location)
        return '' unless location==:head
        js = <<-HTML
        <!-- Analytical Init: Console -->
        <script type="text/javascript">
          console.log('Analytical Init: Console');
        </script>
        HTML
        js
      end

      def track(*args)
        "console.log(\"Analytical Track: #{escape_javascript args.to_json}\");"
      end

      def identify(id, *args)
        "console.log(\"Analytical Identify: #{id} #{escape_javascript args.to_json}\");"
      end

    end
  end
end