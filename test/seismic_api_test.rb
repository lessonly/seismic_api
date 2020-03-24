require "test_helper"

class SeismicAPITest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SeismicAPI::VERSION
  end

  def test_getting_teamsites
    stub = stub_request(:get, "https://api.seismic.com/integration/v2/teamsites")
      .with(headers: { 'Authorization' => 'Bearer someoauthtoken' })
      .to_return(body: [{ "id" => 4, "name" => "SomeTeamsite" }].to_json)

    response = SeismicAPI::Client.new(oauth_token: "someoauthtoken").teamsites.all

    assert_requested(stub)
    assert_equal [{ "id" => 4, "name" => "SomeTeamsite" }], response.body
  end

  def test_finding_single_teamsite
    stub = stub_request(:get, "https://api.seismic.com/integration/v2/teamsites/45")
      .with(headers: { 'Authorization' => 'Bearer someoauthtoken' })
      .to_return(body: { "id" => 45, "name" => "SomeTeamsite" }.to_json)

    response = SeismicAPI::Client.new(oauth_token: "someoauthtoken").teamsites.find(id: 45)

    assert_requested(stub)
    assert_equal({ "id" => 45, "name" => "SomeTeamsite" }, response.body)
  end

  def test_adding_folder_to_teamsite
    stub = stub_request(:post, "https://api.seismic.com/integration/v2/teamsites/32/folders")
      .with(
        headers: { 'Authorization' => 'Bearer someoauthtoken', 'content-type' => 'application/json' },
        body: { name: "Lessonly", parentFolderId: "root" }
      ).to_return(body: { "id" => 32, "name" => "Lessonly" }.to_json)

    response = SeismicAPI::Client.new(oauth_token: "someoauthtoken").teamsites.add_folder(
      teamsiteId: "32",
      name: "Lessonly"
    )

    assert_requested(stub)
    assert_equal({ "id" => 32, "name" => "Lessonly" }, response.body)
  end

  def test_add_url_content_to_teamsite
    stub = stub_request(:post, "#{teamsites_url}/32/urls")
      .with(
        headers: common_post_headers,
        body: {
          url: { url: "www.google.com", openInNewWindow: false },
          name: "Imma Test",
          description: "Itsa Test",
          parentFolderId: "1234",
          externalId: "Lesson/42"
        }
      ).to_return(body: {
        "id" => 32,
        "url" => { "url" => "www.google.com", "openInNewWindow" => false },
        "name" => "Imma Test",
        "description" => "Itsa Test",
        "externalId" => "Lesson/42"
      }.to_json)

    response = SeismicAPI::Teamsites.new(oauth_token: "someoauthtoken")
      .add_url(
        teamsiteId: 32,
        url: { url: "www.google.com", openInNewWindow: false },
        name: "Imma Test",
        description: "Itsa Test",
        parentFolderId: "1234",
        externalId: "Lesson/42"
      )

    assert_requested(stub)
    assert_equal({
      "id" => 32,
      "url" => { "url" => "www.google.com", "openInNewWindow" => false },
      "name" => "Imma Test",
      "description" => "Itsa Test",
      "externalId" => "Lesson/42"
    }, response.body)
  end

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
