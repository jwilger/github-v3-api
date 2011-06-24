require 'rest-client'
require 'json'
require 'github_v3_api/orgs_api'
require 'github_v3_api/org'

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

  def get(path) #:nodoc:
    result = RestClient.get("https://api.github.com" + path,
                            {:accept => :json,
                             :authorization => "token #{@access_token}"})
    JSON.parse(result)
  end
end