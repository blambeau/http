module Http
  module Options
    class Headers

      def initialize(delegate, default_headers = {})
        @delegate = delegate
        @default_headers = default_headers
      end

      def []=(field, value)
        @default_headers[field.to_s.downcase] = value
      end

      def [](field)
        @default_headers[field.to_s.downcase]
      end

      def request(verb, uri, options = {})
        headers = @default_headers.merge(options[:headers] || {})
        options = options.merge(:headers => headers)
        @delegate.request verb, uri, options
      end

    end
  end
end
