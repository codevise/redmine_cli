require 'net/http'
require 'net/https'
require 'json'

module RedmineCLI
  class Task < Thor
    desc 'commit <search> [-a] [-m <msg>] [--prefix=<prefix>]', 'Search for issue and commit with ref.'
    method_option :msg, :type => :string, :aliases => "-m", :desc => 'Commit message.'
    method_option :prefix, :type => :string, :default => 'refs', :desc => 'Prefix like "refs" or "closes" for commit message.'
    method_option :all, :type => :boolean, :aliases => "-a", :desc => 'Passes -a to git commit.'
    def commit(term)
      url = URI.parse("https://redmine.codevise.de/projects/#{project_name}/issues.json?key=#{api_key}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
      response = http.start { |http| http.request(request) }

      matching = JSON.parse(response.body)["issues"].find_all do |issue|
        issue['subject'] =~ /#{term}/i
      end

      if matching.any?
        matching.each_with_index do |issue, index|
          puts "(#{index}) ##{issue['id']} - #{issue['subject']}"
        end

        STDOUT.write "> "
        answer = STDIN.gets.strip
        issue = matching[answer.to_i]

        if !answer.empty? && issue && answer != 'q'
          exec %`git commit -m "#{options[:prefix]} ##{issue['id']}: #{options[:msg]}" #{options[:msg] ? '' : '-e'} #{options[:all] ? '-a' : ''}`
        else
          puts "Bye."
        end
      else
        puts "No matches."
      end
    end

    map 'ci' => :commit

    private

    def project_name
      `git config redmine.project`.strip
    end

    def api_key
      `git config redmine.apikey`.strip
    end
  end
end
