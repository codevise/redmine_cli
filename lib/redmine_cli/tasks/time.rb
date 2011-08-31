require 'net/http'
require 'net/https'

module RedmineCLI
  module Tasks
    class Time < Base
      namespace :time

      desc "out", ""
      def out
        url = URI.parse("https://redmine.codevise.de/worktimes/stop?key=#{api_key}")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
        response = http.start { |http| http.request(request) }

        if response.kind_of?(Net::HTTPSuccess)
          puts "Signed out."
        else
          puts "Error: " + response.class.name
        end
      end

      private

      def api_key
        `git config redmine.apikey`.strip
      end
    end
  end
end
