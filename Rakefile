require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "analytical"
    gem.summary = %Q{Gem for managing multiple analytics services in your rails app.}
    gem.description = %Q{Gem for managing multiple analytics services in your rails app.}
    gem.email = "josh@feefighters.com"
    gem.homepage = "http://github.com/jkrall/analytical"
    gem.authors = ["Joshua Krall", "Nathan Phelps", "Adam Anderson", "Kevin Menard", "Ablyamitov Ablyamit", "Kurt Werle", "Olivier Lauzon", "Daniel Doubrovkine"]
    gem.files = Dir['lib/**/*'] + Dir['app/**/*'] + Dir['rails/**/*']
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
RSpec::Core::RakeTask.new(:rcov)

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "analytical #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
