
module RedmineCLI
  module Tasks
    class List < Base
      namespace :list

      class_option :assigned_to_me, :type => :boolean, :aliases => "-I", :desc => "Only show issues that are assigned to me."

      ['open', 'closed'].each do |status|
        desc "#{status} [term]", "List of all #{status} tickets matching search"
        define_method status do |*args|
          list(status, args.first, options)
        end
      end

      private

      def list(method, term, options)
        query = Query.new.send method
        query = query.subject(term) unless term.nil? or term.empty?
        query = query.assigned_to_me if options.assigned_to_me?
        matching  = query.all

        print(matching)
      end

      def print(issues)
        if issues.any?
          issues.each_with_index do |issue, index|
            puts "##{issue['id']} - #{issue['subject']}"
          end
        else
          puts "No matches."
        end
      end
    end
  end
end
