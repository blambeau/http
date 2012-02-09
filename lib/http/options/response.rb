module Http
  module Options
    class Response
      include Chainable

      def initialize(delegate)
        @delegate = delegate
      end

      def request(verb, uri, options = {})
        response = @delegate.request verb, uri, options
        post_process verb, uri, options, response
      end

      private

      def post_process(verb, uri, options, response)
        case options[:response]
        when :object
          response
        when :parsed_body
          response.parse_body
        when :body
          response.body
        when NilClass
          verb == :head ? response : response.parse_body
        else raise ArgumentError, "invalid response type: #{option}"
        end
      end

    end
  end
end
