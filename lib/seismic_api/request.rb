require "net/http"

module SeismicAPI
  # Request encapsulates the specifics of making requests to the Seismic API
  # for the common http verbs.
  class Request
    def initialize(oauth_token:)
      @oauth_token = oauth_token
    end

    # Get request
    #
    # @param uri [String]
    # @param params [Hash] query params for this request
    #
    # @return [SeismicAPI::Response]

    def get(uri, params: {})
      uri = URI.parse(uri)
      uri.query = URI.encode_www_form(params) if params
      req = Net::HTTP::Get.new(uri)
      if @oauth_token
        req['Authorization'] = "Bearer #{@oauth_token}"
      end

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      Response.new(res).raise_on_error
    end

    # Post request
    #
    # @param uri [String]
    # @param body [#to_json] post body
    #
    # @return [SeismicAPI::Response]

    def post(uri, body: nil)
      uri = URI.parse(uri)
      req = Net::HTTP::Post.new(uri)
      req['Authorization'] = "Bearer #{@oauth_token}"
      req.body = body.to_json if body
      req['Content-Type'] = 'application/json'

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      Response.new(res).raise_on_error
    end

    # Patch request
    #
    # @param uri [String]
    # @param body [#to_json] post body
    #
    # @return [SeismicAPI::Response]

    def patch(uri, body: nil)
      uri = URI.parse(uri)
      req = Net::HTTP::Patch.new(uri)
      req['Authorization'] = "Bearer #{@oauth_token}"
      req.body = body.to_json if body
      req['Content-Type'] = 'application/json'

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      Response.new(res).raise_on_error
    end

    # Put request
    #
    # @param uri [String]
    #
    # @return [SeismicAPI::Response]

    def put(uri)
      uri = URI.parse(uri)
      req = Net::HTTP::Put.new(uri)
      if @oauth_token
        req['Authorization'] = "Bearer #{@oauth_token}"
      end

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      Response.new(res).raise_on_error
    end
  end
end

