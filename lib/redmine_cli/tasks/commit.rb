require 'net/http'
require 'net/https'
require 'json'

module RedmineCLI
  module Tasks
    class Commit < Base
      include Helpers::QueryHelper

      namespace :commit

      class_option :msg, :type => :string, :aliases => "-m", :desc => 'Commit message.'
      class_option :all, :type => :boolean, :aliases => "-a", :desc => 'Passes -a to git commit.'

      class_options_for_query

      ['fixes', 'closes', 'refs'].each do |method|
        desc "#{method} <search> [-a] [-m <msg>] #{options_description_for_query}", "Search for issue and commit with #{method}."
        define_method method do |*args|
          debugger
          commit(args.first, options.merge(:prefix => method))
        end
      end

      private

      def commit(term, options)
        matching = fetch_issues(term, options)

        if issue = RedmineCLI.ui.choose_issue(matching)
          exec %`git commit -m "#{options[:prefix]} ##{issue['id']}: #{options[:msg]}" #{options[:msg] ? '' : '-e'} #{options[:all] ? '-a' : ''}`
        else
          puts "Bye."
        end
      end

      def fetch_issues(term, options)
        puts options.inspect
        puts extract_query_parameters(options).merge!(:term => term).inspect
        create_query_for(extract_query_parameters(options).merge({:term => term})).all
      end

    end
  end
end
