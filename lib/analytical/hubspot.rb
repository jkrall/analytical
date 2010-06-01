module Analytical
  module Hubspot
    class Api
      include Analytical::Base::Api

      def initialize(parent, options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        return '' unless location==:body_append
        js = <<-HTML
        <!-- Analytical Init: Hubspot -->
        <script type="text/javascript" language="javascript">
        var hs_portalid=#{options[:portal_id]};
        var hs_salog_version = "2.00";
        var hs_ppa = "options[:domain]";
        document.write(unescape("%3Cscript src='" + document.location.protocol + "//" + hs_ppa + "/salog.js.aspx' type='text/javascript'%3E%3C/script%3E"));
        </script>
        HTML
        js
      end

    end
  end
end