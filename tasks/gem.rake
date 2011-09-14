desc 'Build gem'
task :gem do
  `gem build redmine_cli.gemspec`
  `mv *.gem gems`
end
