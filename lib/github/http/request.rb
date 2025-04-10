module Github
  class Request
    attr_reader :client, :resource

    BASE_URL = 'https://api.github.com'

    def initialize(client, method, resource)
      @client = client
      @method = method
      @resource = resource
    end

    def perform
      url = URI.parse("#{BASE_URL}#{resource}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      headers = { 'Authorization' => "token #{client.token}" }
      response = http.get(url.path, headers)
      Response.new(response)
    end
  end
end
