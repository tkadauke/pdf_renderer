require 'gemmer'

gemmer 'pdf_renderer'

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the pdf_renderer gem unit tests.'
Rake::TestTask.new(:"test:units") do |t|
  t.libs << 'lib'
  t.pattern = 'test/unit/**/*_test.rb'
  t.verbose = true
end

desc 'Test the pdf_renderer gem functional tests.'
Rake::TestTask.new(:"test:functionals") do |t|
  t.libs << 'lib'
  t.pattern = 'test/functional/**/*_test.rb'
  t.verbose = true
end

task :test => ['test:units', 'test:functionals']

desc 'Generate documentation for the pdf_renderer gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActionFaxer'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :test do
  desc 'Measures test coverage'
  task :coverage do
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov --rails --aggregate coverage.data --text-summary --exclude \"gems/*,rubygems/*,rcov*\" -Ilib"
    system("#{rcov} #{Dir.glob('test/unit/**/*_test.rb').join(' ')}")
    system("#{rcov} --html #{Dir.glob('test/functional/**/*_test.rb').join(' ')}")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
end
