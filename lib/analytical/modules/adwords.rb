module Analytical
  module Modules
    class Adwords
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          @initializing = true
          html = "<!-- Analytical Init: Google Adwords -->\n"
          event_commands = []
          @command_store.commands.each do |c|
            if c[0] == :event
              event_commands << event(*c[1..-1])
            end
          end
          html += event_commands.join("\n")
          @command_store.commands = @command_store.commands.delete_if {|c| c[0] == :event }
          @initializing = false

          html
        end
      end

      #
      # Define conversion events in analytical.yml like:
      #
      # adwords:
      #   'Some Event':
      #     id: 4444555555
      #     language: en
      #     format: 2
      #     color: ffffff
      #     label: xxxxxxxxxxxxxxxx
      #     value: 0
      #   'Another Event':
      #     id: 1111333333
      #     language: en
      #     format: 2
      #     color: ffffff
      #     label: yyyyyyyyyyyyyyyy
      #     value: 0
      #
      def event(name, *args)
        return '' unless @initializing

        data = args.first || {}
        if conversion = options[name.to_sym]
          conversion.symbolize_keys!
          js = <<-HTML
          <script type="text/javascript">
            /* <![CDATA[ */
            var google_conversion_id = #{conversion[:id]};
            var google_conversion_language = "#{conversion[:language]}";
            var google_conversion_format = "#{conversion[:format]}";
            var google_conversion_color = "#{conversion[:color]}";
            var google_conversion_label = "#{conversion[:label]}";
            var google_conversion_value = #{data[:value] || conversion[:value]};
            /* ]]> */
          </script>
          <script type="text/javascript" src="#{protocol}://www.googleadservices.com/pagead/conversion.js"></script>
          <noscript>
            <div style="display:inline;">
            <img height="1" width="1" style="border-style:none;" alt="" src="#{protocol}://www.googleadservices.com/pagead/conversion/#{conversion[:id]}/?label=#{conversion[:label]}&amp;guid=ON&amp;script=0"/>
            </div>
          </noscript>
          HTML
          js
        else
          "<!-- No Adwords Conversion for: #{name} -->"
        end
      end

    end
  end
end