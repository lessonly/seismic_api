module SeismicAPI
  class TestResponses
    def self.find_by_request(request)
      if Teamsites::AllTestResponse.match(request)
        Teamsites::AllTestResponse.new(request)
      end
    end

    class Teamsites::AllTestResponse
      def self.match(request)
        request.path.match(/teamsites$/)
      end

      def initialize(args)
        
      end

      def body
        {}.to_json
      end

      def code
        200
      end

      def success?
        true
      end
    end
  end
end
