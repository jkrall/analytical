module Analytical
  module Modules
    class Google
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :head_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: Google -->
          <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', '#{options[:key]}']);
            _gaq.push(['_setDomainName', '#{options[:domain]}']);
            #{"_gaq.push(['_setAllowLinker', true]);" if options[:allow_linker]}
            _gaq.push(['_trackPageview']);
            (function() {
              var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
              ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
              var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
          </script>
          HTML
          js
        end
      end

      def track(*args)
        "_gaq.push(['_trackPageview'#{args.empty? ? ']' : ', "' + args.first + '"]'});"
      end
      
      def event(name, *args)
        data = args.first || {}
        data = data[:value] if data.is_a?(Hash)
        data_string = !data.nil? ? ", #{data}" : ""
        "_gaq.push(['_trackEvent', \"Event\", \"#{name}\"" + data_string + "]);"
      end
      
      def custom_event(category, action, opt_label=nil, opt_value=nil)
        args = [category, action, opt_label, opt_value].compact
        "_gaq.push(" + [ "_trackEvent", *args].to_json + ");"
      end


      # http://code.google.com/apis/analytics/docs/tracking/gaTrackingCustomVariables.html
      #
      #_setCustomVar(index, name, value, opt_scope)
      #
      # index — The slot for the custom variable. Required. This is a number whose value can range from 1 - 5, inclusive.
      #
      # name —  The name for the custom variable. Required. This is a string that identifies the custom variable and appears in the top-level Custom Variables report of the Analytics reports.
      #
      # value — The value for the custom variable. Required. This is a string that is paired with a name.
      #
      # opt_scope — The scope for the custom variable. Optional. As described above, the scope defines the level of user engagement with your site.
      # It is a number whose possible values are 1 (visitor-level), 2 (session-level), or 3 (page-level).
      # When left undefined, the custom variable scope defaults to page-level interaction.
      def set(data)
        if data.is_a?(Hash) && data.keys.any?
          index = data[:index].to_i
          name  = data[:name ]
          value = data[:value]
          scope = data[:scope]
          if (1..5).to_a.include?(index) && !name.nil? && !value.nil?
            data = "#{index}, '#{name}', '#{value}'"
            data += (1..3).to_a.include?(scope) ? ", #{scope}" : ""
            return "_gaq.push(['_setCustomVar', #{ data }]);"
          end
        end
      end




    end
  end
end