module SeismicAPI
  # Client for all endpoints related to teamsites
  #
  # @example find all teamsites
  #   SeismicAPI::Teamsites.new(oauth_token: "token").all
  #
  # @example add folder to teamsite
  #   SeismicAPI::Teamsites.new(oauth_token: "token")
  #     .add_folder(teamsiteId: "1", name: "My Folder")
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
    # @param url [Hash] Object representing URL to be added
    #   * :url [String] (required) the actual URL the content should link to
    #   * :openInNewWindow [Boolean] (false) Should the content open in a new window
    # @option args [String] :parentFolderId ID of folder to place content in
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

    # Unpublish given library content
    #
    # @param teamsiteId [String] ID of teamsite
    # @param libraryContentId [String] ID of content
    #
    # @return [SeismicAPI::Response]

    def unpublish(teamsiteId:, libraryContentId:)
      request.put(
        "#{teamsites_url}/#{teamsiteId}/items/#{libraryContentId}/unpublish"
      )
    end

    # Query for items
    #
    # @param teamsiteId [String] ID of teamsite
    # @option query [String] :externalId query by externalId
    # @option query [String] :externalConnectionId query by externalConnectionId
    # @return [SeismicAPI::Response]

    def items(teamsiteId:, **query)
      request.get(
        "#{teamsites_url}/#{teamsiteId}/items",
        params: query
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
