
spec = Gem::Specification.new do |spec|
  spec.name = 'redmine_cli'
  spec.version = '0.1.0'  
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

