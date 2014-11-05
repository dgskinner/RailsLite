require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.find { |cookie| cookie.name == "_rails_lite_app" }
      if cookie
        @cookie_val = JSON.parse(cookie.value)
      else
        @cookie_val = {}
      end
    end
  
    def [](key)
      @cookie_val[key]
    end

    def []=(key, val)
      @cookie_val[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      new_cookie = @cookie_val.to_json
      res.cookies << WEBrick::Cookie.new("_rails_lite_app", new_cookie)
    end
  end
end
