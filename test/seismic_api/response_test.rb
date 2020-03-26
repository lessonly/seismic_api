require "test_helper"

module SeismicAPI
  class ResponseTest < Minitest::Test
    def test_raise_on_client_error
      assert_raises(SeismicAPI::HTTPClientError) do
        mock_response = OpenStruct.new(
          code: "404",
          body: { error: { message: "Not Found" }}.to_json
        )

        Response.new(mock_response).raise_on_error
      end
    end

    def test_raise_on_server_error
      assert_raises(SeismicAPI::HTTPServerError) do
        mock_response = OpenStruct.new(
          code: "500",
          body: { error: { message: "It's borked" }}.to_json
        )

        Response.new(mock_response).raise_on_error
      end
    end

    def test_raise_on_bad_request
      assert_raises(SeismicAPI::HTTPBadRequest) do
        mock_response = OpenStruct.new(
          code: "400",
          body: { error: { message: "Bad request" }}.to_json
        )

        Response.new(mock_response).raise_on_error
      end
    end

    def test_raise_on_bad_request_with_empty_body
      assert_raises(SeismicAPI::HTTPBadRequest) do
        mock_response = OpenStruct.new(
          code: "400",
          body: ""
        )

        Response.new(mock_response).raise_on_error
      end
    end

    def test_raise_on_unauthorized
      assert_raises(SeismicAPI::HTTPUnauthorized) do
        mock_response = OpenStruct.new(
          code: "401",
          body: { error: { message: "Unauthorized" }}.to_json
        )

        Response.new(mock_response).raise_on_error
      end
    end

    def test_when_body_is_empty_string
        mock_response = OpenStruct.new(
          code: "400",
          body: ""
        )

        response = Response.new(mock_response)

        assert_equal({}, response.body)
    end
  end
end
