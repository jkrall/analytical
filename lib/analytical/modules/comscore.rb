module Analytical
  module Modules
    class Comscore
      include Analytical::Modules::Base

      def initialize(options={})
        super
        @tracking_command_location = :head_append
      end

      def init_javascript(location)
        init_location(location) do
          js = <<-HTML
          <!-- Analytical Init: comScore -->
          <script>document.write(unescape("%3Cscript src='" + (document.location.protocol == "https:" ? "https://sb" : "http://b") + ".scorecardresearch.com/beacon.js' %3E%3C/script%3E"));</script>
          <script>COMSCORE.beacon({c1:2, c2:#{options[:key]}, c3:"", c4:"", c5:"", c6:"", c15:""});</script>
          <noscript><img src="http://b.scorecardresearch.com/p?c1=2&c2=#{options[:key]}&c3=&c4=&c5=&c6=&c15=&cj=1" /></noscript>
          HTML
          js
        end
      end

    end
  end
end