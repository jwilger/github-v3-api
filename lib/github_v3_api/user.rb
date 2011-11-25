# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Represents a single GitHub User and provides access to its data attributes.
  class User < Entity
    attr_reader :login, :id, :avatar_url, :gravatar_id, :url, :name, :company, 
                :blog, :location, :email, :hireable, :bio, :public_repos, :public_gists, 
                :followers, :following, :html_url, :created_at, :type, :total_private_repos, 
                :owned_private_repos, :private_gists, :disk_usage, :collaborators
    private 

    def natural_key
      [data['login']]
    end
  end
end
