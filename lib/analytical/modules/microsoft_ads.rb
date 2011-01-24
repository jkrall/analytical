module Analytical
  module Modules
    class MicrosoftAds
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          @initializing = true
          html = "<!-- Analytical Init: Microsoft Ads -->\n"
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
      # microsoft_ads:
      #   'Some Event':
      #     id: 55555555-6666-7777-8888-111111111111
      def event(name, *args)
        return '' unless @initializing

        data = args.first || {}
        if conversion = options[name.to_sym]
          conversion.symbolize_keys!
          js = <<-HTML
          <script type="text/javascript">if (!window.mstag) mstag = {loadTag : function(){},time : (new Date()).getTime()};</script>
          <script id="mstag_tops" type="text/javascript" src="//flex.atdmt.com/mstag/site/#{conversion[:id]}/mstag.js"></script>
          <script type="text/javascript"> mstag.loadTag("conversion", {cp:"5050",dedup:"1"})</script>
          <noscript>
            <iframe src="//flex.atdmt.com/mstag/tag/#{conversion[:id]}/conversion.html?cp=5050&dedup=1" frameborder="0" scrolling="no" width="1" height="1" style="visibility:hidden; display:none"></iframe>
          </noscript>
          HTML
          js
        else
          "<!-- No Microsoft Ads Conversion for: #{name} -->"
        end
      end

    end
  end
end

