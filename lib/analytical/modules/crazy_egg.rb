module Analytical
  module Modules
    class CrazyEgg
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          code_url = "#{options[:key].to_s[0,4]}/#{options[:key].to_s[4,4]}"
          js = <<-HTML
          <!-- Analytical Init: CrazyEgg -->
          <script type="text/javascript" src="#{protocol}://s3.amazonaws.com/new.cetrk.com/pages/scripts/#{code_url}.js"> </script>
          HTML
          js
        end
      end

    end
  end
end