require "seismic_api/version"
require "net/http"
require "forwardable"

module SeismicAPI
  class Error < StandardError; end

  module_function def configuration
    @configuration ||= Configuration.new
  end

  module_function def config
    configuration
  end

  module_function def configure
    yield configuration
  end

  class Configuration
    attr_accessor :base_url

    def initialize(args = {})
      @base_url = args.fetch(:base_url) { "https://api.seismic.com/integration/v2" }
    end
  end

  class Response
    attr_reader :raw_response
    extend Forwardable
    def_delegators :@raw_response, :code

    def initialize(response)
      @raw_response = response
    end

    def success?
      @raw_response.is_a?(Net::HTTPSuccess)
    end

    def body
      JSON.parse(@raw_response.body)
    end
  end

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

  class Client
    def initialize(oauth_token:nil)
      @oauth_token = oauth_token
    end

    def teamsites
      Teamsites.new(oauth_token: @oauth_token)
    end
  end

  class Teamsites

    # Initialize teamsites client
    #
    # @param oauth_token [String] valid oauth token
    #
    # @return [self]
    def initialize(oauth_token:)
      @oauth_token = oauth_token
      @base_url = SeismicAPI.config.base_url + "/teamsites"
    end

    # Return all teamsites
    #
    # @return [SeismicAPI::Response]
    def all
      request.get(teamsites_url)
    end

    # Find a specific teamsite
    #
    # @param id [String] id of teamsite
    #
    # @return [SeismicAPI::Response]
    def find(id:)
      request.get("#{teamsites_url}/#{id}")
    end

    # Create a folder in the teamsite
    #
    # @param teamsiteId [String] ID of teamsite
    # @param name [String] name of folder
    # @param parentFolderId [String] ID of parent folder (it not supplied,
    #   it goes into the root directory for that teamsite)
    #
    # @return [SeismicAPI::Response]
    def add_folder(teamsiteId:, name:, parentFolderId: "root")
      request.post(
        "#{teamsites_url}/#{teamsiteId}/folders",
        body: { name: name, parentFolderId: parentFolderId }
      )
    end

    # Add a url as content
    #
    # @param teamsiteId [String] ID of teamsite
    # @param name [String] name to be displayed on the URL content card
    # @param parentFolderId [String] ID of folder to place content in
    # @param url [Hash] Object representing URL to be added
    #   * :url [String] (required) the actual URL the content should link to
    #   * :openInNewWindow [Boolean] (false) Should the content open in a new window
    #
    # @return [SeismicAPI::Response]
    def add_url(teamsiteId:, name:, url:, **args)
      request.post(
        "#{teamsites_url}/#{teamsiteId}/urls",
        body: { url: url, name: name, **args }
      )
    end

    # Publish given library content
    #
    # @param teamsiteId [String] ID of teamsite
    # @param content [Array<{id=>String}>] ids for content to be published
    #
    # @return [SeismicAPI::Response]
    def publish(teamsiteId:, content:, **args)
      request.post(
        "#{teamsites_url}/#{teamsiteId}/publish",
        body: { content: content, **args }
      )
    end

    private

    def request
      Request.new(oauth_token: @oauth_token)
    end

    def teamsites_url
      SeismicAPI.config.base_url + "/teamsites"
    end
  end
end
