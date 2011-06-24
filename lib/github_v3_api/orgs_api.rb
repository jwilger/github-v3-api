# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Provides access to the GitHub Orgs API (http://developer.github.com/v3/orgs/)
  #
  # example:
  #
  #   api = GitHubV3API.new(ACCESS_TOKEN)
  #
  #   # get list of all orgs to which the user belongs
  #   orgs = api.orgs.list
  #   #=> returns an array of GitHubV3API::Org instances
  #
  #   an_org = api.orgs.get('github')
  #   #=> returns an instance of GitHubV3API::Org
  #
  #   an_org.name
  #   #=> 'GitHub'
  #
  class OrgsAPI
    # Typically not used directly. Use GitHubV3API#orgs instead.
    #
    # +connection+:: an instance of GitHubV3API
    def initialize(connection)
      @connection = connection
    end

    # Returns an array of GitHubV3API::Org instances representing the
    # public and private orgs to which the current user belongs.
    def list
      @connection.get('/user/orgs').map do |org_data|
        GitHubV3API::Org.new(self, org_data)
      end
    end

    # Returns a GitHubV3API::Org instance for the specified +org_login+.
    #
    # +org_login+:: the string ID of the organization, e.g. "github"
    def get(org_login)
      org_data = @connection.get("/orgs/#{org_login}")
      GitHubV3API::Org.new_with_all_data(self, org_data)
    end

    def list_repos(org_login)
      @connection.get("/orgs/#{org_login}/repos").map do |repo_data|
        GitHubV3API::Repo.new(@connection.repos, repo_data)
      end
    end
  end
end
