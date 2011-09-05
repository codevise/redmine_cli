
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
        get(:apikey)
      end

    end
  end
end
