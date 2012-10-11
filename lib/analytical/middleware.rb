module Analytical
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      new_commands = env["analytical"]
      if new_commands
        new_commands = JSON(new_commands.to_json) rescue [] # stringify symbols so that the uniq below works.

        cookies = Rack::Request.new(env).cookies

        commands = (JSON(cookies["analytical"]) if cookies["analytical"]) || [] rescue []
        commands = (commands + new_commands).uniq
        Rack::Utils.set_cookie_header!(headers, "analytical", :value => commands.to_json, :path => "/")
      end

      [status, headers, body]
    end

  end
end
