require_dependency "tax_jp/application_controller"

module TaxJp
  class EmploymentInsurancesController < ApplicationController

    def index
      @employment_insurances = TaxJp::LaborInsurances::EmploymentInsurance.find_all
    end

  end
end
