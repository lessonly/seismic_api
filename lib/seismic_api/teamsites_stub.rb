require "webmock"

module SeismicAPI
  class TeamsitesStub
    include WebMock::API

    def items(**args)
      teamsite_id = args.fetch(:teamsite_id, "1")
      item_count = args.fetch(:item_count, 1)
      items = args.fetch(:items) do
        [
          {
            id: "1234arst",
            url: { url: "www.lessonly.com", openInNewWindow: false },
            size: 1234,
            version: "versionnumber"
          }
        ]
      end
      external_id = args.fetch(:external_id, "")
      authorization = args.fetch(:authorization, /Bearer [\w.-]+$/)

      return_body = {
        itemCount: Integer(item_count),
        items: items
      }.to_json

      stub_request(:get, "#{teamsites_url}/#{teamsite_id}/items")
        .with(
          headers: { "Authorization" => authorization },
          query: { externalId: external_id, externalConnectionId: "lessonly" }
      )
        .to_return(body: return_body)
    end

    def add_url(**args)
      teamsite_id = args.fetch(:teamsite_id, "1")
      authorization = args.fetch(:authorization, /Bearer [\w.-]+$/)
      # name = args.fetch(:name, "")
      # description = args.fetch(:description, "")
      # parent_folder_id = args.fetch(:parent_folder_id, "")
      # external_id = args.fetch(:external_id, nil)
      # external_connection_id = args.fetch(:external_connection_id, nil)
      # url = args.fetch(:url)
      # open_in_new_window = args.fetch(:open_in_new_window, false)
      new_url_id = args.fetch(:new_url_id, "32")
      post_body = args.fetch(:post_body)
      return_body = post_body.reject { |k,v| %i(:parentFolderId).include?(k) }

      stub_request(:post, "#{teamsites_url}/#{teamsite_id}/urls")
        .with(
          headers: { "Authorization" => authorization },
          body: post_body
      ).to_return(body: {
        id: new_url_id,
        **return_body
      }.to_json)
    end

    def publish_with_warning(**args)
      teamsite_id = args.fetch(:teamsite_id, "1")
      content_id = args.fetch(:content_id, "1234arst")
      authorization = args.fetch(:authorization, /Bearer [\w.-]+$/)
      return_body = args.fetch(return_body) do
        {
          "totalRequests" => "1",
          "totalErrors" => "0",
          "totalSucceeded" => "1",
          "totalWarnings" => "0",
          "errors" => [],
          "warnings"=>[
            {
              "id"=>String(content_id),
              "message"=>"Content promoted, but could not be published."
            }
          ]
        }
      end

      stub_request(:post, "#{teamsites_url}/#{teamsite_id}/publish")
        .with(
          headers: { "Authorization" => authorization },
          body: {
            content: [
              { id: content_id }
            ]
          }
      ).to_return(body: return_body.to_json)
    end

    def update_content(**args)
      teamsite_id = args.fetch(:teamsite_id, "1")
      content_id = args.fetch(:content_id)
      authorization = args.fetch(:authorization, /Bearer [\w.-]+$/)
      post_body = args.fetch(:post_body)
      return_body = {
        id: "1234arst",
        name: "Some Content",
        url: { url: "www.lessonly.com", openInNewWindow: false },
        size: 1234,
        version: "1.0"
      }.merge(post_body)

      stub_request(:patch, "#{teamsites_url}/#{teamsite_id}/urls/#{content_id}")
        .with(
          headers: { "Authorization" => authorization },
          body: post_body
      ).to_return(body: {
        **return_body
      }.to_json)
    end

    def base_url
      "https://api.seismic.com/integration/v2"
    end

    def teamsites_url
      base_url + "/teamsites"
    end
  end

end
