require_dependency "tax_jp/application_controller"

module TaxJp
  class DepreciationRatesController < ApplicationController
    
    def index
      @depreciation_rates = DepreciationRate.find_all_by_date(Date.today)
    end

  end
end
