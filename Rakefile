begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

require 'closer/tasks'
require 'rake/testtask'

Dir.glob('lib/build_tasks/*.rake').each do |f|
  load f
end

task :test do
  Rake::Task['close'].invoke
end

task default: :test
