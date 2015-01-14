module ActiveModel
  class Serializer
    # Adds to_hash in options to make it work with Sidekiq. It's fixed in AMS 0.10
    # but we're using 0.8
    def as_json(options={})
      if root = options.to_hash.fetch(:root, @options.fetch(:root, root_name))
        @options[:hash] = hash = {}
        @options[:unique_values] = {}

        hash.merge!(root => serializable_hash)
        include_meta hash
        hash
      else
        serializable_hash
      end
    end
  end
end
