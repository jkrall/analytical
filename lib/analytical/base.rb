module Analytical
  module Base
    module Api
      attr_reader :tracking_command_location, :parent, :options
      attr_accessor :commands

      def initialize(_parent, _options={})
        @parent = _parent
        @options = _options
        @tracking_command_location = :body_prepend
        @commands = []
      end

      def track(*args); ''; end
      def identify(*args); ''; end
      def event(*args); ''; end
      def init_javascript; {}; end

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

    end
  end
end