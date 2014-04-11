# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Provides access to the GitHub Users API (http://developer.github.com/v3/users/)
  #
  # example:
  #
  #   api = GitHubV3API.new(ACCESS_TOKEN)
  #
  #   # get list of logged-in user
  #   a_user = api.current
  #   #=> returns an instance of GitHubV3API::User
  #
  #   a_user.login
  #   #=> 'jwilger'
  #
  class UsersAPI
    # Typically not used directly. Use GitHubV3API#users instead.
    #
    # +connection+:: an instance of GitHubV3API
    def initialize(connection)
      @connection = connection
    end

    # Returns a single GitHubV3API::User instance representing the
    # currently logged in user
    def current
      user_data = @connection.get("/user")
      GitHubV3API::User.new(self, user_data)
    end
    
    # Returns a GitHubV3API::User instance for the specified +username+.
    #
    # +username+:: the string login of the user, e.g. "octocat"
    def get(username)
      user_data = @connection.get("/users/#{username}")
      GitHubV3API::User.new_with_all_data(self, user_data)
    end

    # Returns an array of all GitHubV3API::User instances in the server.
    def all
      @connection.get("/users").map do |user_data|
        GitHubV3API::User.new_with_all_data(self, user_data)
      end
    end
  end
end
