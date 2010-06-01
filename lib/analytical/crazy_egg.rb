module Analytical
  module CrazyEgg
    class Api
      include Analytical::Base::Api

      def initialize(parent, options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        return '' unless location==:body_append
        code_url = "#{options[:key][0,4]}/#{options[:key][4,4]}"
        protocol = options[:ssl] ? 'https' : 'http'
        js = <<-HTML
        <!-- Analytical Init: CrazyEgg -->
        <script type="text/javascript" src="#{protocol}://s3.amazonaws.com/new.cetrk.com/pages/scripts/#{code_url}.js"> </script>
        HTML
        js
      end

    end
  end
end