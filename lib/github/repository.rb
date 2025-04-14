module Github
  class Repository
    attr_reader :id, :name, :private

    def initialize(id, name, private)
      @id = id
      @name = name
      @private = private
    end

    class << self
      def all(user, opts = {})
        res = Request.new(user.client, :get, '/user/repos', opts).perform
        res.body.map do |repo|
          new(repo[:id], repo[:name], repo[:private])
        end
      end
    end
  end
end
