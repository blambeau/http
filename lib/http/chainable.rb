module Http
  module Chainable
    # Request a get sans response body
    def head(uri, options = {})
      request :head, uri, {:response => :object}.merge(options)
    end

    # Get a resource
    def get(uri, options = {})
      request :get, uri, options
    end

    # Post to a resource
    def post(uri, options = {})
      request :post, uri, options
    end

    # Put to a resource
    def put(uri, options = {})
      request :put, uri, options
    end

    # Delete a resource
    def delete(uri, options = {})
      request :delete, uri, options
    end

    # Echo the request back to the client
    def trace(uri, options = {})
      request :trace, uri, options
    end

    # Return the methods supported on the given URI
    def options(uri, options = {})
      request :options, uri, options
    end

    # Convert to a transparent TCP/IP tunnel
    def connect(uri, options = {})
      request :connect, uri, options
    end

    # Apply partial modifications to a resource
    def patch(uri, options = {})
      request :patch, uri, options
    end

    # Make an HTTP request with the given verb
    def request(verb, uri, options = {})
      options[:response] ||= :parsed_body

      if options[:headers]
        headers = default_headers.merge options[:headers]
      else
        headers = default_headers
      end

      Client.new.request verb, uri, options.merge(:headers => headers)
    end

    # Make a request with the given headers
    def with_headers(headers)
      Parameters.new default_headers.merge(headers)
    end
    alias_method :with, :with_headers

    # Accept the given MIME type(s)
    def accept(type)
      if type.is_a? String
        with :accept => type
      else
        mime_type = Http::MimeType[type]
        raise ArgumentError, "unknown MIME type: #{type}" unless mime_type
        with :accept => mime_type.type
      end
    end

    def default_headers
      @default_headers ||= {}
    end

    def default_headers=(headers)
      @default_headers = headers
    end
  end
end
