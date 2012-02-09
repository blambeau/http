module Http
  # We all know what HTTP clients are, right?
  class Client
    include Verbs

    # Make an HTTP request
    def request(verb, uri, options = {})
      # prepare raw call arguments
      headers   = options[:headers] || {}
      form_data = options[:form]

      # make raw call
      net_http_response = raw_http_call(verb, uri, headers, form_data)

      # convert and return the response
      http_response = convert_response(net_http_response)
      post_process_response(http_response, options[:response])
    end

    private

    def raw_http_call(method, uri, headers, form_data = nil)
      # Why the FUCK can't Net::HTTP do this?
      uri = URI(uri.to_s) unless uri.is_a? URI

      # Stringify keys :/
      headers = Hash[headers.map{|k,v| [k.to_s, v]}]

      http = Net::HTTP.new(uri.host, uri.port)

      # Why the FUCK can't Net::HTTP do this either?!
      http.use_ssl = true if uri.is_a? URI::HTTPS

      request_class = Net::HTTP.const_get(method.to_s.capitalize)
      request = request_class.new(uri.request_uri, headers)
      request.set_form_data(form_data) if form_data

      http.request(request)
    end

    def convert_response(net_http_response)
      Http::Response.new.tap do |res|
        net_http_response.each_header do |header, value|
          res[header] = value
        end
        res.status = Integer(net_http_response.code) # WTF again Net::HTTP
        res.body   = net_http_response.body
      end
    end

    def post_process_response(response, option)
      case option
      when :object, NilClass
        response
      when :parsed_body
        response.parse_body
      when :body
        response.body
      else raise ArgumentError, "invalid response type: #{option}"
      end
    end

  end
end
