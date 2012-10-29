module RedmineCLI
  class Worktime
    attr_reader :issue_id, :issue_subject, :project_name

    def initialize(attributes)
      @project_name = attributes['project']['name']
      @project_identifier = attributes['project']['identifier']

      if attributes['issue']
        @issue_id = attributes['issue']['id']
        @issue_subject = attributes['issue']['subject']
      end
    end

    def issue?
      !issue_id.nil?
    end

    def self.current
      url = URI.parse("#{Config.url}/worktimes/current?format=json&key=#{Config.api_key}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
      response = http.start { |http| http.request(request) }

      if response.kind_of?(Net::HTTPSuccess)
        Worktime.new(JSON.parse(response.body)['worktime'])
      else
        nil
      end
    end
  end
end
