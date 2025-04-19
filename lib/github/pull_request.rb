# frozen_string_literal: true

module Github
  class PullRequest
    attr_reader :id, :number, :title, :state

    def initialize(id, number, title, state)
      @id = id
      @number = number
      @title = title
      @state = state.to_sym
    end

    class << self
      # https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28#list-pull-requests
      def all(repository, opts = {})
        res = Request.new(repository.owner.client,
                          :get,
                          "/repos/#{repository.owner.name}/#{repository.name}/pulls",
                          opts)
                     .perform
        res.body.map do |pull|
          new(pull[:id], pull[:number], pull[:title], pull[:state])
        end
      end
    end
  end
end
