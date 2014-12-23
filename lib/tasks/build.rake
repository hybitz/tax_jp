require 'rake'

namespace :taxjp do
  task :build do
    js_dir = 'app/assets/javascripts'
    TaxJp::Utils.render 'app/assets/javascripts/tax.js.erb'
  end
end
