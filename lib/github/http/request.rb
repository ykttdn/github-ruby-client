# frozen_string_literal: true

module Github
  module Http
    class Request
      attr_reader :method, :resource, :opts

      BASE_URL = 'https://api.github.com'

      def initialize(method, resource, opts = {})
        @method = method
        @resource = resource
        @opts = opts
      end

      def perform
        full_url = request_url
        uri = URI.parse(full_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        response = case method
                   when :get
                     http.get(full_url, headers)
                   when :post
                     http.post(full_url, opts[:body].to_json, headers)
                   else
                     raise ArgumentError, "Unsupported HTTP method: #{method}"
                   end
        Response.new(response)
      end

      private

      def request_url
        url = "#{BASE_URL}#{resource}"

        if opts[:params] && !opts[:params].empty?
          query = opts[:params].map { |k, v| "#{k}=#{v}" }.join('&')
          url += "?#{query}" unless opts.empty?
        end

        url
      end

      def headers
        {
          Authorization: "token #{Github::Client.token}",
          Accept: 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28'
        }
      end
    end
  end
end
