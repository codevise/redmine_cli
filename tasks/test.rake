require 'rake'
require 'rake/testtask'

task :test => ['test:unit', 'test:acceptance']

namespace :test do
  Rake::TestTask.new('unit') do |t|
    t.libs << 'test'
    t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = true
    t.warning = true
  end

  Rake::TestTask.new('acceptance') do |t|
    t.libs << 'test'
    t.pattern = 'test/acceptance/**/*_test.rb'
    t.verbose = true
    t.warning = true
  end
end
