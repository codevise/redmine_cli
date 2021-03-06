require 'redmine_cli/config'
require 'redmine_cli/query'
require 'redmine_cli/filter'
require 'redmine_cli/tasks'
require 'redmine_cli/cli'
require 'redmine_cli/ui'
require 'redmine_cli/version'
require 'redmine_cli/worktime'

module RedmineCLI
  class << self
    def ui
      @ui ||= UI.new
    end
  end
end
