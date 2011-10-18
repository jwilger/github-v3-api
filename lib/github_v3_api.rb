require 'rest-client'
require 'json'
require 'github_v3_api/entity'
require 'github_v3_api/issues_api'
require 'github_v3_api/issue'
require 'github_v3_api/orgs_api'
require 'github_v3_api/org'
require 'github_v3_api/repos_api'
require 'github_v3_api/repo'

# This is the main entry-point to the GitHub v3 API.
#
# example:
#
#   api = GitHubV3API.new('users_github_oath2_access_token')
#
#   # access the GitHub Orgs API
#   api.orgs
#   #=> an instance of GitHubV3API::OrgsAPI
#
class GitHubV3API
  # Raised when an API request returns a 404 error
  NotFound = Class.new(RuntimeError)

  # Raised when an API request uses an invalid access token
  Unauthorized = Class.new(RuntimeError)

  # Returns a GitHubV3API instance that is able to access github with the
  # +access_token+ owner's authorization.
  #
  # +access_token+:: an OAuth2 access token from GitHub
  def initialize(access_token)
    @access_token = access_token
  end

  # Entry-point for access to the GitHub Orgs API
  #
  # Returns an instance of GitHubV3API::OrgsAPI that will use the access_token
  # associated with this instance.
  def orgs
    OrgsAPI.new(self)
  end

  # Entry-point for access to the GitHub Repos API
  #
  # Returns an instance of GitHubV3API::ReposAPI that will use the access_token
  # associated with this instance.
  def repos
    ReposAPI.new(self)
  end

  def get(path, params={}) #:nodoc:
    result = RestClient.get("https://api.github.com" + path,
                            {:accept => :json,
                             :authorization => "token #{@access_token}"}.merge({:params => params}))
    JSON.parse(result)
  # Entry-point for access to the GitHub Issues API
  #
  # Returns an instance of GitHubV3API::IssuesAPI that will use the access_token
  # associated with this instance
  def issues
    IssuesAPI.new(self)
  end

  rescue RestClient::Unauthorized
    raise Unauthorized, "The access token is invalid according to GitHub"
  end
end
