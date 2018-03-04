require 'rake'
require 'tax_jp'
require 'tax_jp/db_builder'
require 'tax_jp/addresses/db_builder'
require 'tax_jp/corporate_taxes/db_builder'
require 'tax_jp/depreciation_rates/db_builder'
require 'tax_jp/social_insurances/db_builder'
require 'tax_jp/withheld_taxes/db_builder'

namespace :taxjp do
  namespace :build do

    desc '住所DBを構築します。'
    task :address do
      puts '住所'
      fail unless system("bash -ex #{File.dirname(__FILE__)}/download_address.sh")
      TaxJp::Addresses::DbBuilder.new.run
    end

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

    desc '社会保険DBを構築します。'
    task :social_insurance do
      puts '社会保険料'
      TaxJp::SocialInsurances::DbBuilder.new.run
    end

    desc '労働保険DBを構築します。'
    task :labor_insurance do
      puts '雇用保険料'
      TaxJp::LaborInsurances::EmploymentInsuranceDbBuilder.new.run
    end

    desc '源泉徴収税DBを構築します。'
    task :withheld_tax do
      puts '源泉徴収税'
      TaxJp::WithheldTaxes::DbBuilder.new.run
    end

    desc '法人税-区分番号DBを構築します。'
    task :corporate_tax do
      puts '法人税-区分番号'
      TaxJp::CorporateTaxes::DbBuilder.new.run
    end
  end
end
