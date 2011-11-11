module RedmineCLI
  module Tasks
    class List < Base
      include Helpers::QueryHelper

      namespace :list

      ['open', 'closed'].each do |status|
        method_options_for_query :closed_tickets, :all_tickets
        desc "#{status} [term]  #{options_description_for_query}", "List of all #{status} tickets matching search"
        define_method status do |*args|
          list(status, args.first, options)
        end
      end

      method_options_for_query
      desc "sub ID #{options_description_for_query}", "List sub tickets"
      def sub(issue_id)
        query = create_query_for(extract_query_parameters(options))
        matching = Filter.new(query.all).with_parent_id(issue_id).all
        RedmineCLI.ui.list_issues(matching)
      end

      private

      def list(method, term, options)
        matching = create_query_for(extract_query_parameters(options).merge(:status => method.to_sym, :term => term)).all
        RedmineCLI.ui.list_issues(matching)
      end
    end
  end
end
