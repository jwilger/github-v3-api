class GitHubV3API
  class OrgsAPI
    def initialize(connection)
      @connection = connection
    end

    def list
      @connection.get('/user/orgs').map do |org_data|
        GitHubV3API::Org.new(self, org_data)
      end
    end

    def get(org_login)
      org_data = @connection.get("/orgs/#{org_login}")
      GitHubV3API::Org.new_with_all_data(self, org_data)
    end
  end
end
