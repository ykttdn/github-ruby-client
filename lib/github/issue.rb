# frozen_string_literal: true

module Github
  class Issue
    attr_reader :id, :number, :title, :body, :state

    def initialize(id, number, title, body, state)
      @id = id
      @number = number
      @title = title
      @body = body
      @state = state.to_sym
    end

    class << self
      # https://docs.github.com/en/rest/issues/issues?apiVersion=2022-11-28#list-repository-issues
      def all(repository, opts = {})
        res = Request.new(repository.owner.client,
                          :get,
                          "/repos/#{repository.owner.name}/#{repository.name}/issues",
                          opts)
                     .perform
        # GitHub's REST API considers every pull request an issue
        issues = res.body.select do |issue|
          issue[:pull_request].nil?
        end
        issues.map do |issue|
          new(issue[:id], issue[:number], issue[:title], issue[:body], issue[:state])
        end
      end
    end
  end
end
