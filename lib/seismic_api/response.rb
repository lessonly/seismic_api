require "forwardable"

module SeismicAPI
  class Error < StandardError; end

  class SeismicError < Error; end
  class HTTPClientError < SeismicError; end
  class HTTPServerError < SeismicError; end
  class HTTPBadRequest < HTTPClientError; end
  class HTTPUnauthorized < HTTPClientError; end

  # Response represents a response from Seismic.
  #
  # It is returned when using methods in Request.
  # @see SeismicAPI::Request

  class Response
    attr_reader :raw_response
    extend Forwardable
    # def_delegators :@raw_response, :code

    def initialize(response)
      @raw_response = response
    end

    # Was the response code 2xx
    #
    # @return [Boolean]
    def success?
      @raw_response.is_a?(Net::HTTPSuccess)
    end

    def code
      Integer(@raw_response.code)
    end

    # Body of the request
    #
    # @return [Hash] request body
    def body
      return {} if @raw_response.body.strip.empty?

      JSON.parse(@raw_response.body)
    end

    def raise_on_error
      exception_class =
        case code
        when 400; HTTPBadRequest
        when 401; HTTPUnauthorized
        when (400...500); HTTPClientError
        when (500...600); HTTPServerError
        end

      if exception_class
        raise exception_class.new(
          "HTTP code: #{code}, message: #{body.dig("error", "message")}"
        )
      end

      self
    end
  end
end

