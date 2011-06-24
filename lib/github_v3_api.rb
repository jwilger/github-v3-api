require 'rest-client'
require 'json'
require 'github_v3_api/orgs_api'
require 'github_v3_api/org'

class GitHubV3API

  def initialize(access_token)
    @access_token = access_token
  end

  def orgs
    OrgsAPI.new(self)
  end

  def get(path)
    result = RestClient.get("https://api.github.com" + path,
                            {:accept => :json,
                             :authorization => "token #{@access_token}"})
    JSON.parse(result)
  end
end
