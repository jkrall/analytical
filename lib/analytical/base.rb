module Analytical
  module Base
    module Api
      attr_reader :tracking_command_location, :parent, :options, :initialized
      attr_accessor :commands

      def initialize(_parent, _options={})
        @parent = _parent
        @options = _options
        @tracking_command_location = :body_prepend
        @initialized = false
        @commands = []
      end

      # This is used to record page-view events, where you want to pass a URL to an analytics service
      def track(*args); ''; end

      # Identify provides a unique identifier to an analytics service to keep track of the current user
      # id should be a unique string (depending on which service you use), and some services also
      # make use of a data hash as a second parameters, containing :email=>'test@test.com', for instance
      def identify(id, *args); ''; end

      # Event is meant to track important funnel conversions in your app, or other important events
      # that you want to inform a funnel analytics service about.  You can pass optional data to this method as well.
      def event(name, *args); ''; end

      # Set passes some data to the analytics service that should be attached to the current user identity
      # It can be used to set AB-testing choices and other unique data, so that split testing results can be
      # reported by an analytics service
      def set(data); ''; end

      # This method generates the initialization javascript that an analytics service uses to track your site
      def init_javascript(location); ''; end

      def queue(*args)
        if args.first==:identify
          @commands.unshift args
        else
          @commands << args
        end
      end
      def process_queued_commands
        command_strings = @commands.collect {|c| send(*c) }
        @commands = []
        command_strings
      end

      def init_location?(location)
        @tracking_command_location==location
      end

      def init_location(location, &block)
        if init_location?(location)
          @initialized = true
          if block_given?
            yield
          else
            ''
          end
        else
          ''
        end
      end

    end
  end
end