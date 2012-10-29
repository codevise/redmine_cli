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

        if response.kind_of?(Net::HTTPFound)
          puts "Signed out."
        else
          puts "Error: " + response.class.name
        end
      end

      desc "current", ""
      def current
        if worktime = Worktime.current
          if worktime.issue?
            puts "Signed in for ##{worktime.issue_id}: #{worktime.issue_subject}."
          else
            puts "Signed in."
          end
        else
          puts "Not signed in."
        end
      end

      private

      def api_key
        `git config redmine.apikey`.strip
      end
    end
  end
end
