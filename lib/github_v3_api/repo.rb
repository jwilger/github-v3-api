# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Represents a single GitHub Repo and provides access to its data attributes.
  class Repo < Entity
    attr_reader :created_at, :description, :fork, :forks, :has_downloads,
      :has_issues, :has_wiki, :homepage, :html_url, :language, :master_branch,
      :name, :open_issues, :organization, :owner, :parent, :private, :pushed_at,
      :size, :source, :url, :watchers

    def owner_login
      owner['login']
    end

    def collaborators
      api.list_collaborators(owner_login, name)
    end

    private

    def natural_key
      [data['owner']['login'], data['name']]
    end
  end
end
