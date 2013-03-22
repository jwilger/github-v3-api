require 'rest-client'
require 'json'
require 'github_v3_api/entity'
require 'github_v3_api/issues_api'
require 'github_v3_api/issue'
require 'github_v3_api/users_api'
require 'github_v3_api/user'
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

  # Raised when an API request is missing required data
  MissingRequiredData = Class.new(RuntimeError)

  # Returns a GitHubV3API instance that is able to access github with the
  # +access_token+ owner's authorization.
  #
  # +access_token+:: an OAuth2 access token from GitHub
  def initialize(access_token)
    @access_token = access_token
  end

  # Entry-point for access to the GitHub Users API
  #
  # Returns an instance of GitHubV3API::UserAPI that will use the access_token
  # associated with this instance.
  def users
    UsersAPI.new(self)
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

  # Entry-point for access to the GitHub Issues API
  #
  # Returns an instance of GitHubV3API::IssuesAPI that will use the access_token
  # associated with this instance
  def issues
    IssuesAPI.new(self)
  end

  def get(path, params={}) #:nodoc:
    result = RestClient.get("https://api.github.com" + path,
                            {:accept => :json,
                             :authorization => "token #{@access_token}"}.merge({:params => params}))
    result_data = JSON.parse(result)
    # check for pagination
    link = result.headers[:link]
    if link then
      re_relnext = /<https:\/\/api.github.com([^>]*)>; *rel="next"/
      relnext_path = link.match re_relnext
      if relnext_path && relnext_path[1] then
        next_data = self.get(relnext_path[1], params)
        result_data += next_data
      end
    end
    result_data
  rescue RestClient::Unauthorized
    raise Unauthorized, "The access token is invalid according to GitHub"
  end

  def post(path, params={}) #:nodoc:
    result = RestClient.post("https://api.github.com" + path, JSON.generate(params),
                            {:accept => :json,
                             :authorization => "token #{@access_token}"})
    JSON.parse(result)
  rescue RestClient::Unauthorized
    raise Unauthorized, "The access token is invalid according to GitHub"
  end

  def patch(path, params={}) #:nodoc:
    result = RestClient.post("https://api.github.com" + path, JSON.generate(params),
                            {:accept => :json,
                             :authorization => "token #{@access_token}"})
    JSON.parse(result)
  rescue RestClient::Unauthorized
    raise Unauthorized, "The access token is invalid according to GitHub"
  end

  def delete(path) #:nodoc:
    result = RestClient.delete("https://api.github.com" + path,
                            {:accept => :json,
                             :authorization => "token #{@access_token}"})
    JSON.parse(result)
  rescue RestClient::Unauthorized
    raise Unauthorized, "The access token is invalid according to GitHub"
  end
end
