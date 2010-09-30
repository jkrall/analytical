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
          <script src="#{protocol}://static.getclicky.com/js" type="text/javascript"></script>
          <script type="text/javascript">clicky.init('#{@options[:key]}');</script>
          <noscript><p><img alt="Clicky" width="1" height="1" src="#{protocol}://in.getclicky.com/#{@options[:key]}ns.gif" /></p></noscript>
          HTML

          identify_commands = []
          @commands.each do |c|
            if c[0] == :identify
              identify_commands << identify(*c[1..-1])
            end
          end
          js = identify_commands.join("\n") + "\n" + js
          @commands = @commands.delete_if {|c| c[0] == :identify }

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