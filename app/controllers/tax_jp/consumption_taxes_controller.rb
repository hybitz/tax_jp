require_dependency "tax_jp/application_controller"

module TaxJp
  class ConsumptionTaxesController < ApplicationController
    
    def index
      @consumption_taxes = ConsumptionTax.all
    end

  end
end
