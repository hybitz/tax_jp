require 'rake'
require 'tax_jp'
require 'tax_jp/withheld_taxes/db_builder'

namespace :taxjp do
  task :build do
    Rake::Task["taxjp:build:consumption_tax"].invoke
    Rake::Task["taxjp:build:withheld_tax"].invoke
  end

  namespace :build do

    desc '消費税DBを構築します。'
    task :consumption_tax do
      puts '消費税'
      TaxJp::Utils.render 'app/assets/javascripts/tax.js'
    end

    desc '源泉徴収税DBを構築します。'
    task :withheld_tax do
      puts '源泉徴収税'

      db_path = TaxJp::WithheldTax::DB_PATH
      FileUtils.rm_f(db_path)

      TaxJp::WithheldTaxes::DbBuilder.new(db_path).run
    end
  end
end
