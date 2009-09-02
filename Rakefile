require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lighthouse_cli"
    gem.summary = %Q{A quick command line interface to lighthouse.}
    gem.description = %Q{A quick command line interface to lighthouse. The goal is to reduce overhead of tracking tickets inline with normal workflow. The effect is achieved by setting conventions.}
    gem.email = "max@bitsonnet.com"
    gem.homepage = "http://github.com/maxim/lighthouse_cli"
    gem.authors = ["Maxim Chernyak"]
    gem.add_dependency "cldwalker-hirb"
    gem.add_development_dependency "thoughtbot-shoulda"
    gem.files.include %w(Lhcfile lib/lighthouse_cli/* vendor/* vendor/lighthouse-api/* vendor/lighthouse-api/lib/* vendor/lighthouse-api/lib/lighthouse/*)
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lighthouse_cli #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
