module Analytical
  module Modules
    class Clicky
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Clicky -->
          <script type="text/javascript">
            var clicky_site_ids = clicky_site_ids || [];
            clicky_site_ids.push(#{@options[:key]});
            (function() {
              var s = document.createElement('script');
              s.type = 'text/javascript';
              s.async = true;
              s.src = '//static.getclicky.com/js';
              ( document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0] ).appendChild( s );
            })();
          </script>
          <noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/#{@options[:key]}ns.gif" /></p></noscript>
          HTML

          identify_commands = []
          @command_store.commands.each do |c|
            if c[0] == :identify
              identify_commands << identify(*c[1..-1])
            end
          end
          js = identify_commands.join("\n") + "\n" + js
          @command_store.commands = @command_store.commands.delete_if {|c| c[0] == :identify }

          js
        end
      end

      def track(*args)
        "clicky.log(\"#{args.first}\");"
      end

      def identify(id, *args)
        data = { :id=>id }.merge(args.first || {})
        code = <<-HTML
        <script type='text/javascript'>
          var clicky_custom_session = #{data.to_json};
        </script>
        HTML
        code
      end

    end
  end
end
