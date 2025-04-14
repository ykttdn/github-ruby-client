module Github
  class Request
    attr_reader :client, :resource, :opts

    BASE_URL = 'https://api.github.com'

    def initialize(client, method, resource, opts = {})
      @client = client
      @method = method
      @resource = resource
      @opts = opts
    end

    def perform
      full_url = request_url
      uri = URI.parse(full_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response = http.get(full_url, headers)
      Response.new(response)
    end

    private

    def request_url
      url = "#{BASE_URL}#{resource}"
      query = opts.map { |k, v| "#{k}=#{v}" }.join('&')
      url += "?#{query}" unless opts.empty?
      url
    end

    def headers
      {
        'Authorization': "token #{client.token}",
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28'
      }
    end
  end
end
