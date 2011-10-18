# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Provides access to the GitHub Issues API (http://developer.github.com/v3/issues/)
  #
  # example:
  #
  #   api = GitHubV3API.new(ACCESS_TOKEN)
  #
  #   # get list of your issues
  #   my_issues = api.issues.list
  #   #=> returns an array of GitHubV3API::Issue instances
  #
  #   # get list of issues for a repo
  #   repo_issues = api.issues.list({:user => 'octocat', :repo => 'hello-world'})
  #   #=> returns an array of GitHubV3API::Issue instances
  #
  #   issue = api.issues.get('octocat', 'hello-world', '1234')
  #   #=> returns an instance of GitHubV3API::Issue
  #
  #   issue.title
  #   #=> 'omgbbq'
  #
  class IssuesAPI
    # Typically not used directly. Use GitHubV3API#issues instead.
    #
    # +connection+:: an instance of GitHubV3API
    def initialize(connection)
      @connection = connection
    end

    # Returns an array of GitHubV3API::Issue instances representing a
    # user's issues or issues for a repo
    def list(options=nil, params={})
      path = if options && options[:user] && options[:repo]
        "/repos/#{options[:user]}/#{options[:repo]}/issues"
      else
        '/issues'
      end

      @connection.get(path, params).map do |issue_data|
        GitHubV3API::Issue.new(self, issue_data)
      end
    end

    # Returns a GitHubV3API::Issue instance for the specified +user+,
    # +repo_name+, and +id+.
    #
    # +user+:: the string ID of the user, e.g. "octocat"
    # +repo_name+:: the string ID of the repository, e.g. "hello-world"
    # +id+:: the integer ID of the issue, e.g. 42
    def get(user, repo_name, id, params={})
      issue_data = @connection.get("/repos/#{user}/#{repo_name}/issues/#{id.to_s}", params)
      GitHubV3API::Issue.new_with_all_data(self, issue_data)
    rescue RestClient::ResourceNotFound
      raise NotFound, "The issue #{user}/#{repo_name}/issues/#{id} does not exist or is not visible to the user."
    end
  end
end