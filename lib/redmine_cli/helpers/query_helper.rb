
module RedmineCLI
  module Helpers
    module QueryHelper

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        @@query_options = [{ :name =>  :closed_tickets, :type => :boolean, :aliases => "-C", :desc => 'Only search for closed tickets.' },
                           { :name =>  :all_tickets, :type => :boolean, :aliases => "-A", :desc => 'Include all tickets into search.' },
                           { :name =>  :assigned_to_me, :type => :boolean, :aliases => "-I", :desc => "Only show issues that are assigned to me." },
                           { :name =>  :global_search, :type => :boolean, :aliases => "-G", :desc => "Perform a global search." },
                           { :name =>  :project_id, :type => :string, :aliases => "-P", :desc => "Search in the project with the given id." }]

        def class_options_for_query
          options_for_query :class_option, []
        end

        def method_options_for_query(*excludes)
          options_for_query :method_option, excludes
        end

        def options_description_for_query(*excludes)
          @@query_options.select { |option| !excludes.include?(option[:name])}
            .collect { |option| "[#{option[:aliases]}]" }.join(" ")
        end

        private

        def options_for_query(method, excludes)
          @@query_options.each do |option|
            unless excludes.include?(option[:name])
              self.send method,  option[:name], :type => option[:type], :aliases => option[:aliases], :desc => option[:desc]
            end
          end
        end

      end

      def extract_query_parameters(options)
        params = {};

        params[:status] = :open
        params[:status] = :closed_option if options.closed_tickets? && !options.all_tickets
        params[:status] = :all if options.all_tickets?

        params[:assigned_to_me] = options.assigned_to_me?

        params[:project_id] = options.project_id
        params[:global_search] = options.global_search?

        params
      end

      def create_query_for(params)
        query = Query.new
        query = add_project(query, params)
        query = add_status(query, params)
        query = query.assigned_to_me if params[:assigned_to_me]
        query = query.subject(params[:term]) unless params[:term].nil?
        query
      end

      private

      def add_project(query, params)
        query.project = options.project_id if !params[:global_search] && params[:project_id]
        query.default_project if !params[:global_search] && params[:project_id]
        query
      end

      def add_status(query, params)
        if params[:status] == :open
          query.open
        elsif params[:status] == :clossed
          query.closed
        else
          query
        end
      end

    end
  end
end
