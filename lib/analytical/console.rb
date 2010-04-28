module Analytical
  module Console
    class Api
      include Analytical::Base::Api

      def initialize(parent, options={})
        super
        @tracking_command_location = :body_prepend
      end

      def init_javascript
        js_blocks = {}
        js_blocks[:body_prepend] = <<-HTML
        <!-- Analytical Init: Console -->
        <script type="text/javascript">
          console.log('Analytical Init: Console');
        </script>
        HTML
        js_blocks
      end

      def track(*args)
        "console.log('Analytical Track: #{args.to_json}');"
      end

      def identify(*args)
        "console.log('Analytical Identify: #{args.to_json}');"
      end

    end
  end
end