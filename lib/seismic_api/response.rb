require "forwardable"

module SeismicAPI
  class Response
    attr_reader :raw_response
    extend Forwardable
    def_delegators :@raw_response, :code

    def initialize(response)
      @raw_response = response
    end

    # Was the response code 2xx
    #
    # @return [Boolean]
    def success?
      @raw_response.is_a?(Net::HTTPSuccess)
    end

    # Body of the request
    #
    # @return [Hash] request body
    def body
      JSON.parse(@raw_response.body)
    end
  end
end

