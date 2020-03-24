require "test_helper"

module SeismicAPI
  class TeamsitesTest < Minitest::Test
    def test_publish
      stub = stub_request(:post, "#{teamsites_url}/32/publish")
        .with(
          headers: common_post_headers,
          body: {
            content: [
              { id: "831" }
            ]
          }
      ).to_return(body: {
        "totalRequests" => "1",
        "totalErrors" => "0",
        "totalSucceeded" => "1",
        "totalWarnings" => "0",
        "errors" => [],
        "warnings" => []
      }.to_json)

      response = SeismicAPI::Teamsites.new(oauth_token: "someoauthtoken")
        .publish(
          teamsiteId: 32,
          content: [
            { id: "831" }
          ]
      )

      assert_requested(stub)
      assert_equal({
        "totalRequests" => "1",
        "totalErrors" => "0",
        "totalSucceeded" => "1",
        "totalWarnings" => "0",
        "errors" => [],
        "warnings" => []
      }, response.body)
    end

    def test_unpublish
      stub = stub_request(:put, "#{teamsites_url}/32/items/831/unpublish")

      SeismicAPI::Teamsites.new(oauth_token: "someoauthtoken")
        .unpublish(
          teamsiteId: 32,
          libraryContentId: 831
      )

      assert_requested(stub)
    end

    def test_query_items
      return_body = {
            itemCount: "1",
            items: {
              url: { url: "www.lessonly.com", openInNewWindow: false },
              size: 1234,
              version: "versionnumber"
            }
      }.to_json

      stub = stub_request(:get, "https://api.seismic.com/integration/v2/teamsites/45/items")
        .with(
          headers: { 'Authorization' => 'Bearer someoauthtoken' },
          query: { externalId: "Lesson/52" }
        )
        .to_return(body: return_body)

      response = SeismicAPI::Teamsites.new(oauth_token: "someoauthtoken").items(
        teamsiteId: 45,
        externalId: "Lesson/52"
      )

      assert_requested(stub)
      assert_equal(JSON.parse(return_body), response.body)
    end

    def base_url
      "https://api.seismic.com/integration/v2"
    end

    def teamsites_url
      base_url + "/teamsites"
    end

    def common_headers
      { 'Authorization' => 'Bearer someoauthtoken' }
    end

    def common_post_headers
      common_headers.merge({ 'content-type' => 'application/json' })
    end
  end
end
