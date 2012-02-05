
require 'uri'
require 'net/http'
require 'net/https'
require 'json'

module RedmineCLI
  class Query

    attr_reader :filters
    attr_accessor :project

    def initialize(query = nil)
      @filters = if query.nil?
                   []
                 else
                   query.filters.clone
                 end
      @project = query.project if query
    end

    def add_filter(field, operator, values)
      filters << {:field => field, :operator => operator, :values => (values.is_a?(Array) ? values : [values])}
      self
    end

    def execute
      issues, totalCount, page = [], 0, 1

      begin
        puts url_for(99, page)
        url = URI.parse(url_for(99, page))

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = url.scheme == "https"

        request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
        response = http.start { |http| http.request(request) }
        data = JSON.parse(response.body);

        totalCount = data["total_count"].to_i
        issues.concat(data["issues"])

        page += 1
      end until issues.length == totalCount || data["issues"].empty?

      issues
    end
    alias :all :execute

    [{:name => 'open', :operator => 'o'}, {:name => 'closed', :operator => 'c'}].each do |query|
      define_method query[:name] do
        Query.new(self).add_filter('status_id', query[:operator], 1)
      end
    end

    def subject(*values)
      Query.new(self).add_filter('subject', '~', values)
    end

    def default_project
      @project = Config.project
      self
    end

    def assigned_to_me
      Query.new(self).add_filter('assigned_to_id', '=', 'me')
    end

    private

    def url_for(limit, page)
      "#{Config.url}#{resource}?key=#{Config.api_key}&limit=#{limit}&page=#{page}&#{query}"
    end

    def resource
      prefix = if @project
                 "/projects/#{@project}"
               else
                 ""
               end
      prefix + "/issues.json"
    end

    def query
      parts = filters.collect do |filter|
        values = filter[:values].collect { |v| "values[#{filter[:field]}][]=#{URI.escape(v.to_s)}" }
        "fields[]=#{filter[:field]}&operators[#{filter[:field]}]=#{filter[:operator]}&#{values.join('&')}"
      end

      parts.join('&')
    end

  end
end
