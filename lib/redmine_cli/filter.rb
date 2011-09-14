module RedmineCLI
  class Filter
    def initialize(issues)
      @issues = issues
    end

    def with_parent_id(issue_id)
      filtered_issues = @issues.find_all do |issue|
        issue['parent'] && issue['parent']['id'].to_s == issue_id.to_s
      end

      Filter.new(filtered_issues)
    end


    def with_id(issue_id)
      filtered_issues = @issues.find_all do |issue|
        issue['id'].to_s == issue_id.to_s
      end

      Filter.new(filtered_issues)
    end

    def all
      @issues
    end
  end
end
