# frozen_string_literal: true

require 'dotenv'

Dotenv.load('.env')
token = ENV.fetch('GH_PAT')

require_relative 'lib/github_client'

Github::Client.token = token
user = Github::User.me
repo = user.repos(sort: :updated, direction: :desc).first
repo.pulls(state: :all)
repo.issues(state: :all)

issue_title = 'New issue'
issue_body = <<~BODY
  # Overview
  This is a test issue created using the GitHub API.
  Markdown is supported in the body of the issue, for example:
  - **bold text**
  - _italic text_
  - [GitHub Markdown Guide](https://guides.github.com/features/mastering-markdown/)
BODY
issue = Github::Issue.create(repo, title: issue_title, body: issue_body)
issue.number

issue.update(title: 'Updated issue title')
issue.title

issue.close(:completed)
issue.state
