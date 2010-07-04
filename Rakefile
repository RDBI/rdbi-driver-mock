require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rdbi-driver-mock"
    gem.summary = %Q{Mock Driver for RDBI, used for testing}
    gem.description = gem.summary
    gem.email = "erik@hollensbe.org"
    gem.homepage = "http://github.com/erikh/rdbi-driver-mock"
    gem.authors = ["Erik Hollensbe"]

    gem.add_development_dependency 'test-unit'
    gem.add_development_dependency 'yard'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |yard|
    yard.files   = %w[lib/**/*.rb README*]
    yard.options = %w[--protected --private ]
  end
  
  task :rdoc => [:yard]
  task :clobber_rdoc => [:yard]
rescue LoadError => e
  [:rdoc, :yard, :clobber_rdoc].each do |my_task|
    task my_task do
      abort "YARD is not available, which is needed to generate this documentation"
    end
  end
end
