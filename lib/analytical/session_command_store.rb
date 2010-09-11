module Analytical
  class SessionCommandStore
    attr_reader :session, :module_key

    def initialize(session, module_key, initial_list=nil)
      @session = session
      @module_key = module_key
      @session_key = ('analytical_'+module_key.to_s).to_sym
      ensure_session_setup!(initial_list)
    end

    def assign(v)
      self.commands = v
    end

    def commands
      @session[@session_key]
    end
    def commands=(v)
      @session[@session_key] = v
    end

    def flush
      self.commands = []
    end

    # Pass any array methods on to the internal array
    def method_missing(method, *args, &block)
      commands.send(method, *args, &block)
    end

    private

    def ensure_session_setup!(initial_list=nil)
      self.commands ||= (initial_list || [])
    end

  end
end