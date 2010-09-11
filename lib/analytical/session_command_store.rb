module Analytical
  class SessionCommandStore
    attr_reader :session, :module_key

    def initialize(session, module_key, initial_list=nil)
      @session = session
      @module_key = module_key
      ensure_session_array!(initial_list)
    end

    def commands
      ensure_session_setup!
      @session[:analytical][@module_key]
    end
    def commands=(v)
      ensure_session_setup!
      @session[:analytical][@module_key] = v
    end

    def flush
      self.commands = []
    end

    # Pass any array methods on to the internal array
    def method_missing(method, *args, &block)
      ensure_session_array!
      commands.send(method, *args, &block)
    end

    private

    def ensure_session_setup!
      @session[:analytical] ||= {}
    end

    def ensure_session_array!(initial_list=nil)
      self.commands ||= initial_list || []
    end

  end
end