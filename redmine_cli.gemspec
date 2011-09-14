lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'redmine_cli/version'

spec = Gem::Specification.new do |spec|
  spec.name = 'redmine_cli'
  spec.version = RedmineCLI::VERSION
  spec.summary = spec.description = "Command line util for redmine."
  spec.authors = ["Tim Fischbach", "Gregor Weckbecker"]
  spec.email = "info@codevise.de"
  spec.homepage = "http://codevise.de"

  spec.add_dependency('thor', '>= 0.14.6')

  spec.files = `git ls-files`.split("\n")
  spec.require_path = ["lib"]
  spec.bindir = "bin"
  spec.executables = "redmine"
end
