require "bundler/gem_tasks"

require 'rake/testtask'
 
Rake::TestTask.new do |t|
  t.libs << 'lib/paperclip-watermark'
  t.test_files = FileList['test/lib/paperclip-watermark/*_test.rb']
  t.verbose = true
end
 
task :default => :test
