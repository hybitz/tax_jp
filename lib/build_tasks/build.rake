require 'rake'
require 'tax_jp'
require 'tax_jp/depreciation_rates/db_builder'
require 'tax_jp/social_insurances/db_builder'
require 'tax_jp/withheld_taxes/db_builder'

namespace :taxjp do
  task :build do
    Rake::Task["taxjp:build:consumption_tax"].invoke
    Rake::Task["taxjp:build:depreciation_rate"].invoke
    Rake::Task["taxjp:build:social_insurance"].invoke
    Rake::Task["taxjp:build:withheld_tax"].invoke
  end

  namespace :build do

    desc '消費税DBを構築します。'
    task :consumption_tax do
      puts '消費税'
      TaxJp::Utils.render 'app/assets/javascripts/tax.js'
    end

    desc '減価償却率DBを構築します。'
    task :depreciation_rate do
      puts '減価償却率'
      TaxJp::DepreciationRates::DbBuilder.new.run
    end

    desc '社会保険料DBを構築します。'
    task :social_insurance do
      puts '社会保険料'
      TaxJp::SocialInsurances::DbBuilder.new.run
    end

    desc '源泉徴収税DBを構築します。'
    task :withheld_tax do
      puts '源泉徴収税'
      TaxJp::WithheldTaxes::DbBuilder.new.run
    end

  end
end
