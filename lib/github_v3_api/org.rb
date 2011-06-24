# See GitHubV3API documentation in lib/github_v3_api.rb
class GitHubV3API
  # Represents a single GitHub Org and provides access to its data attributes.
  class Org
    def self.new_with_all_data(api, org_data) #:nodoc:
      org = self.allocate
      org.initialize_fetched(api, org_data)
      org
    end

    # +api+:: an instance of GitHubV3API::OrgsAPI
    # +org_data+:: a Hash with keys corresponding to the org data supported by
    #              GitHub
    #
    def initialize(api, org_data)
      @api = api
      @org_data = org_data
    end

    def initialize_fetched(api, org_data) #:nodoc:
      initialize(api, org_data)
      @fetched = true
    end

    def [](key) #:nodoc:
      fetch_data unless @fetched
      @org_data[key]
    end

    def self.attr_reader(*fields) #:nodoc:
      fields.each do |field|
        define_method field do
          self[field.to_s]
        end
      end
    end

    attr_reader :avatar_url, :billing_email, :blog, :collaborators,
      :company, :created_at, :disk_usage, :email, :followers, :following,
      :html_url, :id, :location, :login, :name, :owned_private_repos, :plan,
      :private_gists, :private_repos, :public_gists, :public_repos, :space,
      :total_private_repos, :type, :url

    protected

    def org_data #:nodoc:
      @org_data
    end

    private

    def fetch_data #:nodoc:
      result = @api.get(@org_data['login'])
      @org_data = result.org_data
      @fetched = true
    end
  end
end
