module Http
  module Options
    class Headers
      include Chainable

      def initialize(delegate, default_headers = {})
        @delegate = delegate
        @default_headers = default_headers
      end

      def request(verb, uri, options = {})
        headers = @default_headers.merge(options[:headers] || {})
        options = options.merge(:headers => headers)
        @delegate.request verb, uri, options
      end

    end
  end
end
