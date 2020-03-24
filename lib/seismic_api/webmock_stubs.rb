module SeismicAPI
  module WebmockStubs
    def successful_publish_stub(teamsiteId: "32", contentId: "831")
      stub_request(:post, "#{teamsites_url}/#{teamsiteId}/publish")
        .with(
          headers: common_post_headers,
          body: {
            content: [
              { id: contentId }
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
    end
  end
end
