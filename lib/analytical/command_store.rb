module Analytical
  class CommandStore
    attr_accessor :commands

    def initialize(initial_list=nil)
      @commands = initial_list || []
    end

    def flush
      @commands = []
    end

    # Pass any array methods on to the internal array
    def method_missing(method, *args, &block)
      @commands.send(method, *args, &block)
    end

  end
end