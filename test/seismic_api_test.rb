require "test_helper"

class SeismicApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SeismicApi::VERSION
  end

  def test_it_does_something_useful
    assert true
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

    response = SeismicAPI::Client.new(oauth_token: "someoauthtoken").teamsites(id: 32).add_folder(name: "Lessonly")

    assert_requested(stub)
    assert_equal({ "id" => 32, "name" => "Lessonly" }, response.body)
  end
end
