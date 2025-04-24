# frozen_string_literal: true

module Github
  class User
    attr_reader :name, :id

    def initialize(name, id)
      @name = name
      @id = id
    end

    class << self
      # https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28#get-the-authenticated-user
      def load
        res = Http::Request.new(:get, '/user').perform
        new(res.body[:login], res.body[:id])
      end
    end

    def repos(opts = {})
      Repository.all(self, opts)
    end
  end
end
