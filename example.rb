require 'dotenv'

Dotenv.load('.env')
token = ENV.fetch('GH_PAT')

require_relative 'lib/github_client'

client = Github::Client.new(token)
user = client.user
repos = user.repos(sort: :updated, direction: :desc)
