module RedmineCLI
  class UI
    def list_issues(issues)
      if issues.any?
        issues.each_with_index do |issue, index|
          show_issue(issue)
        end
      else
        puts "No matches."
      end
    end

    def choose_issue(issues)
      if issues.any?
        issues.each_with_index do |issue, index|
          puts "(#{index}) ##{issue['id']} - #{issue['subject']}"
        end

        STDOUT.write "Choose issue (Default: 0)> "
        answer = STDIN.gets.strip

        if answer == 'q'
          nil
        elsif answer.empty?
          issues.first
        else
          issues[answer.to_i]
        end
      else
        puts "No matches."
      end
    end

    def show_issue(issue)
      if issue
        puts "##{issue['id']} - #{issue['subject']}"
      else
        puts "Not found."
      end
    end

    def show_full_issue(issue)
      if issue
        puts "##{issue['id']} - #{issue['subject']}\n\n#{issue['description']}"
      else
        puts "Not found."
      end
    end
  end
end
