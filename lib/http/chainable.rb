module Http
  module Chainable
    include Verbs

    # Make an HTTP request with the given verb
    def request(verb, uri, options = {})
      options[:response] ||= (verb == :head ? :object : :parsed_body)

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
