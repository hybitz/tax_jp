require "bundler/setup"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

require "bundler/gem_tasks"

Dir.glob('lib/build_tasks/*.rake').each do |f|
  load f
end
