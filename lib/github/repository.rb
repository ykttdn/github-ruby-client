# frozen_string_literal: true

module Github
  class Repository
    attr_reader :id, :name, :owner, :private

    def initialize(id, name, owner, private)
      @id = id
      @name = name
      @owner = owner
      @private = private
    end

    class << self
      def all(user, opts = {})
        res = Request.new(user.client, :get, '/user/repos', opts).perform
        res.body.map do |repo|
          new(repo[:id], repo[:name], user, repo[:private])
        end
      end
    end

    def pulls(opts = {})
      PullRequest.all(self, opts)
    end
  end
end
