module Analytical
  class Middleware

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      new_events_data = env["analytical"]
      if new_events_data
        response = Rack::Response.new(body, status, headers)
        cookies = env["rack.cookies"] || {}

        events_data = (JSON(cookies["analytical"]) if cookies["analytical"]) || [] rescue []
        events_data.concat(new_events_data)
        response.set_cookie("analytical", { :value => events_data.to_json, :path => "/" })
        response.finish
      else
        [status, headers, body]
      end
    end

  end
end
