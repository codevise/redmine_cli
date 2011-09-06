
module RedmineCLI
  class Config
    class << self

      def get(key)
        value = `git config redmine.#{key.to_s}`.strip
        raise Thor::Error, "Config key 'redmine.#{key.to_s}' not found! (e.g. `git config redmine.#{key.to_s} VALUE`)" if value.empty?
        value
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
