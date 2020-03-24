require "seismic_api/version"
require "seismic_api/request"
require "seismic_api/response"
require "seismic_api/teamsites"

module SeismicAPI
  class Error < StandardError; end

  # Access the current configuration
  module_function def configuration
    @configuration ||= Configuration.new
  end

  # Alias so that we can refer to configuration as config
  module_function def config
    configuration
  end

  # Configure the library
  #
  # @yieldparam [SeismicAPI::Configuration] current_configuration
  #
  # @example
  #   SeismicAPI.configure do |config|
  #     config.base_url = "www.foobar.com"
  #   end
  #
  # @yieldreturn [SeismicAPI::Configuration]
  module_function def configure
    yield configuration
  end

  class Configuration
    attr_accessor :base_url

    def initialize(args = {})
      @base_url = args.fetch(:base_url) { "https://api.seismic.com/integration/v2" }
    end
  end

  class Client
    def initialize(oauth_token:nil)
      @oauth_token = oauth_token
    end

    # Access the teamsites client
    #
    # @return [SeismicAPI::Client::Teamsites]
    def teamsites
      Teamsites.new(oauth_token: @oauth_token)
    end
  end
end
