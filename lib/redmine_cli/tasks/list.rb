
require 'net/http'
require 'net/https'
require 'json'

module RedmineCLI
  module Tasks
    class List < Base
      namespace :list

      desc "open [term]", "List of all open tickets matching search"
      def open(term = "")
        matching = fetch_issues.find_all do |issue|
          issue['subject'] =~ /#{term}/i
        end

        if matching.any?
          matching.each_with_index do |issue, index|
            puts "##{issue['id']} - #{issue['subject']}"
          end
        else
          puts "No matches."
        end
      end

      private

      def fetch_issues
        issues, totalCount, page = [], 0, 1

        begin
          url = URI.parse(url_for(99, page))

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true

          request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
          response = http.start { |http| http.request(request) }
          data = JSON.parse(response.body);

          totalCount = data["total_count"].to_i
          issues.concat(data["issues"])

          page += 1
        end until issues.length == totalCount || data["issues"].empty?

        issues
      end

      def url_for(limit, page)
        "https://redmine.codevise.de/projects/#{project_name}/issues.json?key=#{api_key}&limit=#{limit}&page=#{page}"
      end

      def project_name
        `git config redmine.project`.strip
      end

      def api_key
        `git config redmine.apikey`.strip
      end
    end
  end
end
