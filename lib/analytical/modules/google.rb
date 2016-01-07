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
          js = <<-HTML.gsub(/^ {10}/, '')
          <!-- Analytical Init: Google -->
          <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
            
            ga('create', '#{options[:key]}', 'auto');#{linkid}
            ga('send', 'pageview');
          </script>
          HTML
          js
        end
      end

      # note that "Session Unification" must be enabled in the GA User-ID feature
      # because the page view event happens before the identify
      def identify(*args) # id, options
        <<-JS.gsub(/^ {10}/, '')
          ga('set', 'userId', id);
        JS
      end

      def track(*args) # page
        <<-JS.gsub(/^ {10}/, '')
          ga('send', 'pageview', page);
        JS
      end

      def event(*args) # name, options, callback
        <<-JS.gsub(/^ {10}/, '')
          ga('send', 'event', name, options && options.action || 'undefined', options && options.label, options && options.value);
        JS
      end
      
      def linkid
        if options[:linkid]
          "\n  ga('require', 'linkid', 'linkid.js');"
        end
      end

      # def track(*args)
      #   "_gaq.push(['_trackPageview'#{args.empty? ? ']' : ', "' + args.first + '"]'});"
      # end

      # def custom_event(category, action, opt_label=nil, opt_value=nil)
      #   args = [category, action, opt_label, opt_value].compact
      #   "_gaq.push(" + [ "_trackEvent", *args].to_json + ");"
      # end

      # # http://code.google.com/apis/analytics/docs/tracking/gaTrackingCustomVariables.html
      # #
      # #_setCustomVar(index, name, value, opt_scope)
      # #
      # # index — The slot for the custom variable. Required. This is a number whose value can range from 1 - 5, inclusive.
      # #
      # # name —  The name for the custom variable. Required. This is a string that identifies the custom variable and appears in the top-level Custom Variables report of the Analytics reports.
      # #
      # # value — The value for the custom variable. Required. This is a string that is paired with a name.
      # #
      # # opt_scope — The scope for the custom variable. Optional. As described above, the scope defines the level of user engagement with your site.
      # # It is a number whose possible values are 1 (visitor-level), 2 (session-level), or 3 (page-level).
      # # When left undefined, the custom variable scope defaults to page-level interaction.
      # def set(data)
      #   if data.is_a?(Hash) && data.keys.any?
      #     index = data[:index].to_i
      #     name  = data[:name ]
      #     value = data[:value]
      #     scope = data[:scope]
      #     if (1..5).to_a.include?(index) && !name.nil? && !value.nil?
      #       data = "#{index}, '#{name}', '#{value}'"
      #       data += (1..3).to_a.include?(scope) ? ", #{scope}" : ""
      #       return "_gaq.push(['_setCustomVar', #{ data }]);"
      #     end
      #   end
      # end
      # 
      # # http://code.google.com/apis/analytics/docs/gaJS/gaJSApiEcommerce.html#_gat.GA_Tracker_._addTrans
      # # String orderId      Required. Internal unique order id number for this transaction.
      # # String affiliation  Optional. Partner or store affiliation (undefined if absent).
      # # String total        Required. Total dollar amount of the transaction.
      # # String tax          Optional. Tax amount of the transaction.
      # # String shipping     Optional. Shipping charge for the transaction.
      # # String city         Optional. City to associate with transaction.
      # # String state        Optional. State to associate with transaction.
      # # String country      Optional. Country to associate with transaction.
      # def add_trans(order_id, affiliation=nil, total=nil, tax=nil, shipping=nil, city=nil, state=nil, country=nil)
      #   data = []
      #   data << "'#{order_id}'"
      #   data << "'#{affiliation}'"
      #   data << "'#{total}'"
      #   data << "'#{tax}'"
      #   data << "'#{shipping}'"
      #   data << "'#{city}'"
      #   data << "'#{state}'"
      #   data << "'#{country}'"
      # 
      #   "_gaq.push(['_addTrans', #{data.join(', ')}]);"
      # end
      # 
      # # http://code.google.com/apis/analytics/docs/gaJS/gaJSApiEcommerce.html#_gat.GA_Tracker_._addItem
      # # String orderId  Optional Order ID of the transaction to associate with item.
      # # String sku      Required. Item's SKU code.
      # # String name     Required. Product name. Required to see data in the product detail report.
      # # String category Optional. Product category.
      # # String price    Required. Product price.
      # # String quantity Required. Purchase quantity.
      # def add_item(order_id, sku, name, category, price, quantity)
      #   data  = "'#{order_id}', '#{sku}', '#{name}', '#{category}', '#{price}', '#{quantity}'"
      #   "_gaq.push(['_addItem', #{data}]);"
      # end
      # 
      # # http://code.google.com/apis/analytics/docs/gaJS/gaJSApiEcommerce.html#_gat.GA_Tracker_._trackTrans
      # # Sends both the transaction and item data to the Google Analytics server.
      # # This method should be used in conjunction with the add_item and add_trans methods.
      # def track_trans
      #   "_gaq.push(['_trackTrans']);"
      # end

    end
  end
end
