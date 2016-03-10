lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'sqlite3'
require 'bundler/gem_tasks'
require 'closer/tasks'

Dir.glob('lib/build_tasks/*.rake').each do |f|
  load f
end

task :test do
  Rake::Task['close'].invoke
end
