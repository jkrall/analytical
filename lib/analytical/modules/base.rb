module Analytical
  module Modules
    module Base
      attr_reader :tracking_command_location, :options, :initialized
      attr_reader :command_store

      def initialize(_options={})
        @options = _options
        @tracking_command_location = :body_prepend
        @initialized = false
        @command_store = @options[:session_store] || Analytical::CommandStore.new
      end

      def protocol
        @options[:ssl] ? 'https' : 'http'
      end

      #
      # The core methods that most analytics services implement are listed below.
      # Modules will ignore any calls that they don't respond to, allowing them to
      # only partially implement this basic template (or implement their own arbitrary custom methods)
      #

      # This is used to record page-view events, where you want to pass a URL to an analytics service
      # def track(*args)

      # Identify provides a unique identifier to an analytics service to keep track of the current user
      # id should be a unique string (depending on which service you use), and some services also
      # make use of a data hash as a second parameters, containing :email=>'test@test.com', for instance
      # def identify(id, *args)

      # Event is meant to track important funnel conversions in your app, or other important events
      # that you want to inform a funnel analytics service about.  You can pass optional data to this method as well.
      # def event(name, *args)

      # Set passes some data to the analytics service that should be attached to the current user identity
      # It can be used to set AB-testing choices and other unique data, so that split testing results can be
      # reported by an analytics service
      # def set(data)

      # This method generates the initialization javascript that an analytics service uses to track your site
      # def init_javascript(location)

      def queue(*args)
        return if @options[:ignore_duplicates] && @command_store.include?(args)
        if args.first==:identify
          @command_store.unshift args
        else
          @command_store << args
        end
      end
      def process_queued_commands
        command_strings = @command_store.collect do |c|
          send(*c) if respond_to?(c.first)
        end.compact
        @command_store.flush
        command_strings
      end

      def init_location?(location)
        if @tracking_command_location.is_a?(Array)
          @tracking_command_location.map { |item|item.to_sym }.include?(location.to_sym)
        else
          @tracking_command_location.to_sym == location.to_sym
        end
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
