module Http
  module Utils
    class Cache
      include Chainable

      Key = Struct.new(:verb, :uri)

      def initialize(delegate = nil, cache = nil)
        delegate, cache = nil, delegate if delegate.is_a? Hash
        @delegate = delegate
        @cache    = warmup(cache || {})
      end

      def request(verb, uri, options = {})
        if options[:nocache]
          by_delegate verb, uri, options
        else
          key = Key.new(verb, uri)
          @cache[key] ||= by_delegate(verb, uri, options)
        end
      end

      private

      def warmup(cache)
        warmup = {}
        cache.each_pair do |request,response|
          verb, url = Array(request)
          verb, url = :get, verb if url.nil?
          unless response.is_a?(Http::Response)
            code, headers, body = Array(response)
            code, headers, body = 200, {}, code if headers.nil?
            response = Http::Response.new.tap do |r|
              r.status  = code
              r.headers = headers
              r.body    = body
            end
          end
          warmup[Key.new(verb,url)] = response
        end
        warmup
      end

      def by_delegate(verb, uri, options)
        if @delegate
          @delegate.request verb, uri, options
        else
          Http::Response.new.tap do |r|
            r.status  = 404
            r.headers = {"content-type" => "text/plain"}
            r.body    = "Not found #{uri} (#{verb.upcase})"
          end
        end
      end

    end
  end
end
