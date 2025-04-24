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
      def all(repository, params = {})
        res = Http::Request.new(:get,
                                "/repos/#{repository.owner.name}/#{repository.name}/issues",
                                params:)
                           .perform
        # GitHub's REST API considers every pull request an issue
        issues = res.body.select do |issue|
          issue[:pull_request].nil?
        end
        issues.map do |issue|
          new(issue[:id], issue[:number], issue[:title], issue[:body], issue[:state])
        end
      end

      # https://docs.github.com/en/rest/issues/issues?apiVersion=2022-11-28#create-an-issue
      def create(repository, title:, body:)
        res = Http::Request.new(:post,
                                "/repos/#{repository.owner.name}/#{repository.name}/issues",
                                body: {
                                  title:,
                                  body:
                                }).perform
        new(res.body[:id], res.body[:number], res.body[:title], res.body[:body], res.body[:state])
      end
    end
  end
end
