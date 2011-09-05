
module RedmineCLI
  class Config
    class << self

      def get(key)
        `git config redmine.#{key.to_s}`.strip
      end

      def url
        get(:url)
      end

      def project
        get(:project)
      end

      def api_key
        get_with_fallback(:api_key, :apikey)
      end

      private

      def get_with_fallback(key, fallback_key)
        value = get(key)
        return get(fallback_key) if value.nil? or value.empty?
        value
      end

    end
  end
end
