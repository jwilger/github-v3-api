class GitHubV3API
  class Entity
    def self.new_with_all_data(api, data) #:nodoc:
      entity = allocate
      entity.initialize_fetched(api, data)
      entity
    end

    def initialize(api, data)
      @api = api
      @data = data
    end

    def initialize_fetched(api, data) #:nodoc:
      initialize(api, data)
      @fetched = true
    end

    def [](key) #:nodoc:
      fetch_data unless @fetched
      @data[key]
    end

    def self.attr_reader(*fields) #:nodoc:
      fields.each do |field|
        define_method field do
          self[field.to_s]
        end
      end
    end

    protected

    def data #:nodoc:
      @data
    end

    private

    def fetch_data #:nodoc:
      result = @api.get(*natural_key)
      @data = result.data
      @fetched = true
    end
  end
end
