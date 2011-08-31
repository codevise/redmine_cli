require 'net/http'
require 'net/https'
require 'json'

module RedmineCLI
  class Task < Thor
    class_option :msg, :type => :string, :aliases => "-m", :desc => 'Commit message.'
    class_option :all, :type => :boolean, :aliases => "-a", :desc => 'Passes -a to git commit.'

    desc 'commit <search> [-a] [-m <msg>] [--prefix=<prefix>]', 'Search for issue and commit with ref.'
    method_option :prefix, :type => :string, :default => 'refs', :desc => 'Prefix like "refs" or "closes" for commit message.'
    def commit(term)
      matching = fetch_issues.find_all do |issue|
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

    ['fixes', 'closes', 'refs'].each do |method|
      desc "#{method} <search> [-a] [-m <msg>]", "Search for issue and commit with #{method}."
      define_method method do |*args|
        invoke RedmineCLI::Task, :commit, args, options.merge(:prefix => method)
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
