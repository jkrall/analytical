module Analytical
  module Adwords
    class Api
      include Analytical::Base::Api

      def initialize(parent, options={})
        super
        @tracking_command_location = :body_append
      end

      def init_javascript(location)
        return ''
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
        html = ''
        if conversion = options[name]
          html = <<-HTML
          <!-- Google Code for PPC Landing Page Conversion Page -->
          <script type="text/javascript">
            /* <![CDATA[ */
            var google_conversion_id = #{conversion[:id]};
            var google_conversion_language = "#{conversion[:language]}";
            var google_conversion_format = "#{conversion[:format]}";
            var google_conversion_color = "#{conversion[:color]}";
            var google_conversion_label = "#{conversion[:label]}";
            var google_conversion_value = #{conversion[:value]};
            /* ]]> */
          </script>
          <script type="text/javascript" src="http://www.googleadservices.com/pagead/conversion.js"></script>
          <noscript>
            <div style="display:inline;">
            <img height="1" width="1" style="border-style:none;" alt="" src="http://www.googleadservices.com/pagead/conversion/#{conversion[:id]}/?label=#{conversion[:label]}&amp;guid=ON&amp;script=0"/>
            </div>
          </noscript>
          HTML
        end
        html
      end

    end
  end
end