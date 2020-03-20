require "seismic_api/version"
require "net/http"
require "forwardable"

module SeismicAPI
  class Error < StandardError; end
  class Response
    attr_reader :raw_response
    extend Forwardable
    def_delegators :@raw_response, :code

    def initialize(response)
      @raw_response = response
    end

    def success?
      @raw_response.is_a?(Net::HTTPOK)
    end

    def body
      JSON.parse(@raw_response.body)
    end
  end

  class Client
    def initialize(oauth_token:nil)
      @oauth_token = oauth_token
    end

    def teamsites(id: nil)
      Teamsites.new(oauth_token: @oauth_token, id: id)
    end
  end

  class Teamsites
    def initialize(oauth_token:,id:nil)
      @oauth_token = oauth_token
      @id = id
    end

    def all
      uri = URI.parse("https://api.seismic.com/integration/v2/teamsites")
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{@oauth_token}"

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      Response.new(res)
    end

    def find(id: @id)
      uri = URI.parse("https://api.seismic.com/integration/v2/teamsites/#{id}")
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{@oauth_token}"

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      Response.new(res)
    end

    def add_folder(teamsite_id: @id, name:, parent_folder_id: "root")
      uri = URI.parse("https://api.seismic.com/integration/v2/teamsites/#{teamsite_id}/folders")
      req = Net::HTTP::Post.new(uri)
      req['Authorization'] = "Bearer #{@oauth_token}"
      req.body = { name: name, parentFolderId: parent_folder_id }.to_json
      req['Content-Type'] = 'application/json'

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      Response.new(res)
    end
  end
end
