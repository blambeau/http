module Http
  module Verbs

    # Request a get sans response body
    def head(uri, options = {})
      request :head, uri, options
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

  end
end
