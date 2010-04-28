module Analytical

  class Api
    attr_accessor :options, :modules

    def initialize(options={})
      @options = options
      @modules = @options[:modules].inject(ActiveSupport::OrderedHash.new) do |h, m|
        h[m] = {
          :initialized => false,
          :api => "Analytical::#{m.to_s.camelize}::Api".constantize.new(self, @options[m])
        }
        h
      end
    end

    #
    # Generic track command that each module should implement to support basic page/event tracking
    # Returns javascript to be inserted at arbitrary position on page,
    # or stores the track command if the module hasn't been initialized yet
    #
    def track(*args)
      process_command(:track, *args)
    end

    #
    # Generic track command that each module should implement to support basic page/event tracking
    # Returns javascript to be inserted at arbitrary position on page,
    # or stores the track command if the module hasn't been initialized yet
    #
    def identify(*args)
      process_command(:track, *args)
    end

    #
    # These methods return the javascript that should be inserted into each section of your layout
    #
    def head_javascript
      [init_javascript(:head), tracking_javascript(:head)].delete_if{|s| s.blank?}.join("\n")
    end
    def body_prepend_javascript
      [init_javascript(:body_prepend), tracking_javascript(:body_prepend)].delete_if{|s| s.blank?}.join("\n")
    end
    def body_append_javascript
      [init_javascript(:body_append), tracking_javascript(:body_append)].delete_if{|s| s.blank?}.join("\n")
    end

    private

    def process_command(command, *args)
      @modules.values.collect do |m|
        if m[:initialized]
          m[:api].send command, *args
        else
          m[:api].queue command, *args
          ''
        end
      end.delete_if {|mstr| mstr.blank?}.join("\n")
    end

    def tracking_javascript(location)
      commands = []
      @modules.each do |name, m|
        commands += m[:api].process_queued_commands if m[:api].tracking_command_location==location
      end
      commands = commands.delete_if{|c| c.blank? || c.empty?}
      unless commands.empty?
        commands.unshift "<script type='text/javascript'>"
        commands << "</script>"
      end
      commands.join("\n")
    end

    def init_javascript(location)
      @modules.values.collect do |m|
        m[:initialized] = true if m[:api].tracking_command_location==location
        m[:api].init_javascript[location]
      end.join("\n")
    end
  end

end