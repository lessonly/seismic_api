require "net/http"

module SeismicAPI
  class Request
    def initialize(oauth_token: nil)
      @oauth_token = oauth_token
    end

    def get(uri)
      uri = URI.parse(uri)
      req = Net::HTTP::Get.new(uri)
      if @oauth_token
        req['Authorization'] = "Bearer #{@oauth_token}"
      end

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      Response.new(res)
    end

    def post(uri, body: nil)
      uri = URI.parse(uri)
      req = Net::HTTP::Post.new(uri)
      req['Authorization'] = "Bearer #{@oauth_token}"
      req.body = body.to_json if body
      req['Content-Type'] = 'application/json'

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      Response.new(res)
    end
  end
end

