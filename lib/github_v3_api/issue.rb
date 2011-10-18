# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Represents a single GitHub Issue and provides access to its data attributes.
  class Issue < Entity
    attr_reader :url, :html_url, :number, :state, :title, :body, :user,
                :labels, :assignee, :milestone, :comments, :pull_request,
                :closed_at, :created_at, :updated_at


  end
end