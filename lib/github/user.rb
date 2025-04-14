module Github
  class User
    attr_reader :client, :name, :id

    def initialize(client, name, id)
      @client = client
      @name = name
      @id = id
    end

    class << self
      def load(client)
        res = Request.new(client, :get, '/user').perform
        new(client, res.body[:login], res.body[:id])
      end
    end

    def repos(opts = {})
      Repository.all(self, opts)
    end
  end
end
