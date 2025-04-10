module Github
  class Client
    attr_reader :token

    def initialize(token)
      @token = token
    end

    def user
      User.load(self)
    end
  end
end
