module RedmineCLI
  module Tasks
    class Show < Base
      namespace :show

      desc "desc ID", "Show ticket"
      def desc(issue_id)
        matching = Filter.new(Query.new.all).with_id(issue_id).all
        RedmineCLI.ui.show_full_issue(matching[0])
      end
    end
  end
end
