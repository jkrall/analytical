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
            if(typeof(console) !== 'undefined' && console != null) {
              console.log('Analytical Init: Console');
            }
          </script>
          HTML
          js
        end
      end

      def track(*args)
        check_for_console <<-HERE
        console.log("Analytical Track: "+"#{escape args.first}");
        HERE
      end

      def identify(id, *args)
        data = args.first || {}
        check_for_console <<-HERE
        console.log("Analytical Identify: "+"#{escape id}");
        console.log(#{data.to_json});
        HERE
      end

      def event(name, *args)
        data = args.first || {}
        check_for_console <<-HERE
        console.log("Analytical Event: "+"#{escape name}");
        console.log(#{data.to_json});
        HERE
      end

      def set(data)
        check_for_console <<-HERE
        console.log("Analytical Set: ");
        console.log(#{data.to_json});
        HERE
      end

      def alias_identity(old_identity,new_identity)
        check_for_console <<-HERE
        console.log("Analytical Alias: #{old_identity} => #{new_identity}");
        HERE
      end

      private

      CONSOLE_JS_ESCAPE_MAP = {
        '\\' => '\\\\',
        '</' => '<\/',
        "\r\n" => '\n',
        "\n" => '\n',
        "\r" => '\n',
        '"' => '\\"',
        "'" => "\\'"
      } unless defined?(CONSOLE_JS_ESCAPE_MAP)

      def escape(js)
        js.to_s.gsub(/(\\|<\/|\r\n|[\n\r"'])/) { CONSOLE_JS_ESCAPE_MAP[$1] }
      end

      def check_for_console(data)
        "if(typeof(console) !== 'undefined' && console != null) { \n#{data} }"
      end

    end
  end
end
