require 'gemmer'

gemmer 'pdf_renderer'

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the action_faxer plugin unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the action_faxer plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActionFaxer'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :test do
  desc 'Measures test coverage'
  task :coverage do
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov --rails --aggregate coverage.data --text-summary --exclude \"gems/*,rubygems/*,rcov*\" -Ilib"
    system("#{rcov} --html #{Dir.glob('test/**/*_test.rb').join(' ')}")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
end
