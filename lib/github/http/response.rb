module Github
  class Response
    attr_reader :code, :headers, :body

    def initialize(response)
      @code = response.code
      @headers = response.each_header.to_h
      @raw_body = response.body

      begin
        @body = JSON.parse(@raw_body, symbolize_names: true)
      rescue JSON::ParseError
        @body = @raw_body
      end
    end
  end
end
