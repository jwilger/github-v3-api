class GitHubV3API
  # This is the base class used for value objects returned by the API. See
  # descendent classes for more details.
  class Entity
    def self.new_with_all_data(api, data) #:nodoc:
      entity = allocate
      entity.initialize_fetched(api, data)
      entity
    end

    # +api+:: an instance of the API class associated with the subclass of
    #         Entity being instantiated.
    # +data+:: a Hash with keys corresponding to the data fields for the
    #          subclass of Entity being instantiated
    def initialize(api, data)
      @api = api
      @data = data
    end

    def initialize_fetched(api, data) #:nodoc:
      initialize(api, data)
      @fetched = true
    end

    def [](key) #:nodoc:
      if @data[key].nil? && !@fetched
        fetch_data
      end
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

    # Provides access to the raw data hash for subclasses.
    def data
      @data
    end

    private

    def fetch_data #:nodoc:
      result = @api.get(*natural_key)
      @data = result.data
      @fetched = true
    end

    # Provides access to the api object for subclasses
    def api
      @api
    end
  end
end
