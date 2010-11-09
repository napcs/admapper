# -*- encoding: utf-8 -*-
 
Gem::Specification.new do |s|
  s.name = %q{admapper}
  s.version = "0.0.3"
 
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Hogan"]
  s.date = %q{2010-11-08}
  s.email = %q{brianhogan@napcs.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "LICENSE", "Rakefile", "init.rb", "lib/admapper.rb",  "lib/admapper/extensions.rb", "lib/admapper/connection.rb",  "lib/admapper/group.rb", "lib/admapper/configuration.rb","lib/admapper/user.rb"]
  s.homepage = %q{http://www.napcs.com/projects/}
  s.rdoc_options = ["--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.requirements = ["net-ldap"]
  s.rubyforge_project = %q{admapper}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Friendly mixin for working with Microsoft's ActiveDirectory}
 
  s.add_dependency(%q<net-ldap>, ["= 0.1.1"])
  s.add_development_dependency(%q<mocha>, ["= 0.9.8"])
  
  
end
