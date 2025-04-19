# frozen_string_literal: true

module Github
  class User
    attr_reader :client, :name, :id

    def initialize(client, name, id)
      @client = client
      @name = name
      @id = id
    end

    class << self
      # https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28#get-the-authenticated-user
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
