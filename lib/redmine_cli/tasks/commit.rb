require 'net/http'
require 'net/https'
require 'json'

module RedmineCLI
  module Tasks
    class Commit < Base
      namespace :commit

      class_option :msg, :type => :string, :aliases => "-m", :desc => 'Commit message.'
      class_option :all, :type => :boolean, :aliases => "-a", :desc => 'Passes -a to git commit.'
      class_option :closed_tickets, :type => :boolean, :aliases => "-C", :desc => 'Only search for closed tickets.'
      class_option :all_tickets, :type => :boolean, :aliases => "-A", :desc => 'Include all tickets into search.'
      class_option :assigned_to_me, :type => :boolean, :aliases => "-I", :desc => "Only show issues that are assigned to me."

      ['fixes', 'closes', 'refs'].each do |method|
        desc "#{method} [<search>] [-a] [-m <msg>] [-A | -C] [-I]", "Search for issue and commit with #{method}."
        long_desc <<-DOC
          If <search> is present, the command displays a list of issues
          with matching sujects.  If no <search> is given, the command
          tries to determine the issue from the current worktime. 
        DOC
        define_method method do |*args|
          commit(args.first, options.merge(:prefix => method))
        end
      end

      private

      def commit(term, options)
        if term.nil?
          worktime = Worktime.current

          if worktime && worktime.issue?
            issue = {
              'id' => worktime.issue_id
            }
          else
            puts "Cannot determine issue from worktime. Not signed in for any issue."
            return
          end
        else
          matching = fetch_issues(term, options)
          issue = RedmineCLI.ui.choose_issue(matching)

          unless issue
            puts "Bye."
            return
          end
        end

        exec %`git commit -m "#{options[:prefix]} ##{issue['id']}: #{options[:msg]}" #{options[:msg] ? '' : '-e'} #{options[:all] ? '-a' : ''}`
      end

      def fetch_issues(term, options)
        query = Query.new

        query = query.closed if not options.all_tickets and options.closed_tickets
        query = query.assigned_to_me if options.assigned_to_me?
        query = query.open unless options.all_tickets or options.closed_tickets
        query = query.subject(term) unless term.nil? or term.empty?

        query.all
      end
    end
  end
end
