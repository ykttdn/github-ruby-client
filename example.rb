# frozen_string_literal: true

require 'dotenv'

Dotenv.load('.env')
token = ENV.fetch('GH_PAT')

require_relative 'lib/github_client'

client = Github::Client.new(token)
user = client.user
repo = user.repos(params: { sort: :updated, direction: :desc }).first
repo.pulls(params: { state: :all })
repo.issues(params: { state: :all })
