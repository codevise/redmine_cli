module RedmineCLI
  module Tasks
    class List < Base
      namespace :list

      class_option :assigned_to_me, :type => :boolean, :aliases => "-I", :desc => "Only show issues that are assigned to me."

      method_option :global_search, :type => :boolean, :aliases => "-G", :desc => "Perform a global search."
      method_option :project_id, :type => :string, :aliases => "-P", :desc => "Search in the project with the given id."
      ['open', 'closed'].each do |status|
        desc "#{status} [term] [-I]", "List of all #{status} tickets matching search"
        define_method status do |*args|
          list(status, args.first, options)
        end
      end

      desc "sub ID [-A | -C] [-I]", "List sub tickets"
      method_option :closed_tickets, :type => :boolean, :aliases => "-C", :desc => 'Only search for closed tickets.'
      method_option :all_tickets, :type => :boolean, :aliases => "-A", :desc => 'Include all tickets into search.'
      method_option :assigned_to_me, :type => :boolean, :aliases => "-I", :desc => "Only show issues that are assigned to me."
      def sub(issue_id)
        query = Query.new

        query = query.closed if not options.all_tickets and options.closed_tickets
        query = query.open if !options.all_tickets and !options.closed_tickets
        query = query.assigned_to_me if options.assigned_to_me?
        matching = Filter.new(query.all).with_parent_id(issue_id).all

        RedmineCLI.ui.list_issues(matching)
      end

      private

      def list(method, term, options)
        query = Query.new.send method

        query.project = options.project_id if !options.global_search? && options.project_id
        query.default_project if !options.global_search? && !options.project_id

        query = query.subject(term) unless term.nil? or term.empty?
        query = query.assigned_to_me if options.assigned_to_me?
        matching  = query.all

        RedmineCLI.ui.list_issues(matching)
      end
    end
  end
end
