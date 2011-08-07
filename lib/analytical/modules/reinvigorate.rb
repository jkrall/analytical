module Analytical
  module Modules
    class Reinvigorate
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Reinvigorate -->
          <script type="text/javascript">
            document.write(unescape("%3Cscript src='" + (("https:" == document.location.protocol) ? "https://ssl-" : "http://")
            + "include.reinvigorate.net/re_.js' type='text/javascript'%3E%3C/script%3E"));
          </script>
          HTML
          js
        end
      end

      def identify(id, *args)
        data = args.first || {}
        "var re_name_tag = \"#{id}\";"
      end

      def context(data)
        return '' if data.blank?
        if data[:email]
          "var re_context_tag = \"mailto:#{data[:email]}\";"
        elsif data[:url]
          "var re_context_tag = \"http://#{data[:url]}\";"
        else
          "var re_context_tag = \"#{data.first.last}\";"
        end
      end

      def track(data, *args)
        "try {
          reinvigorate.track(\"#{options[:key]}\");
        } catch(err) {}"
      end

    end
  end
end