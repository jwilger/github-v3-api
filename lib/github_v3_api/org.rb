# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Represents a single GitHub Org and provides access to its data attributes.
  class Org < Entity
    attr_reader :avatar_url, :billing_email, :blog, :collaborators,
      :company, :created_at, :disk_usage, :email, :followers, :following,
      :html_url, :id, :location, :login, :name, :owned_private_repos, :plan,
      :private_gists, :private_repos, :public_gists, :public_repos, :space,
      :total_private_repos, :type, :url

    private 

    def natural_key
      [data['login']]
    end
  end
end
