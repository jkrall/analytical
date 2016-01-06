module Analytical
  module Modules
    class Console
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Console -->
          <script type="text/javascript">
            if (typeof(console) !== 'undefined' && console != null) {
              console.log('Analytical Init: Console');
            }
          </script>
          HTML
          js
        end
      end

      def identify(*args) # id, options
        <<-JS.gsub(/^ {10}/, '')
          if (typeof(console) !== 'undefined' && console != null) {
            console.log('Analytical identify', arguments)
          }
        JS
      end

      def track(*args) # page
        <<-JS.gsub(/^ {10}/, '')
          if (typeof(console) !== 'undefined' && console != null) {
            console.log('Analytical track', arguments)
          }
        JS
      end

      def event(*args) # name, options
        <<-JS.gsub(/^ {10}/, '')
          if (typeof(console) !== 'undefined' && console != null) {
            console.log('Analytical event', arguments)
          }
        JS
      end

      def set(*args) # properties
        <<-JS.gsub(/^ {10}/, '')
          if (typeof(console) !== 'undefined' && console != null) {
            console.log('Analytical set', arguments)
          }
        JS
      end

      def alias_identity(*args) # old_identity, new_identity
        <<-JS.gsub(/^ {10}/, '')
          if (typeof(console) !== 'undefined' && console != null) {
            console.log('Analytical alias_identity', arguments)
          }
        JS
      end

    end
  end
end
