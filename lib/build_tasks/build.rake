require 'rake'
require 'tax_jp'

namespace :taxjp do
  task :build do
    TaxJp::Utils.render 'app/assets/javascripts/tax.js'
  end
end
