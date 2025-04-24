# frozen_string_literal: true

module Github
  class Issue
    attr_reader :id, :repository, :number
    attr_accessor :title, :body, :state

    def initialize(id, repository, number, title, body, state)
      @id = id
      @repository = repository
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
          new(issue[:id], repository, issue[:number], issue[:title], issue[:body], issue[:state])
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
        new(res.body[:id], repository, res.body[:number], res.body[:title], res.body[:body], res.body[:state])
      end
    end

    # https://docs.github.com/en/rest/issues/issues?apiVersion=2022-11-28#update-an-issue
    def update(title: nil, body: nil, state: nil, state_reason: nil)
      request_body = {}
      request_body[:title] = title if title
      request_body[:body] = body if body
      request_body[:state] = state if %i[open closed].include?(state)
      request_body[:state_reason] = state_reason if state_reason

      res = Http::Request.new(:patch,
                              "/repos/#{repository.owner.name}/#{repository.name}/issues/#{number}",
                              body: request_body).perform

      self.title = res.body[:title] if title
      self.body = res.body[:body] if body
      self.state = res.body[:state].to_sym if state

      self
    end

    def close(state_reason = :completed)
      update(state: :closed, state_reason:)
    end
  end
end
