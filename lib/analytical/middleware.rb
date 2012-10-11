module Analytical
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      new_commands = env["analytical"]
      if new_commands
        response = Rack::Response.new(body, status, headers)
        cookies = env["rack.cookies"] || {}

        commands = (JSON(cookies["analytical"]) if cookies["analytical"]) || [] rescue []
        commands.concat(new_commands)
        response.set_cookie("analytical", { :value => commands.to_json, :path => "/" })
        response.finish
      else
        [status, headers, body]
      end
    end

  end
end
