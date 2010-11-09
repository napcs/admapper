require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
 
$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'ADMapper'

desc "Run the tests"
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

Rake::TestTask.new(:t) do |t|
  t.libs << 'test'
  t.pattern = ENV["TEST"]
  t.verbose = true
end

desc 'Start an IRB session with all necessary files required.'
task :shell do |t|
  chdir File.dirname(__FILE__)
  exec 'irb -I lib/ -I lib/ADMapper -r rubygems -r net-ldap -r tempfile -r init'
end

desc 'Generate documentation for ADMapper'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = 'ADMapper'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end