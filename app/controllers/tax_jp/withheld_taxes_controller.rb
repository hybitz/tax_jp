require_dependency "tax_jp/application_controller"

module TaxJp
  class WithheldTaxesController < ApplicationController
    before_action :preload_finder

    def index
      @withheld_taxes = TaxJp::WithheldTax.find_all_by_date(@finder.from)
    end

    private
    
    def preload_finder
      @finder = TaxJp::Finder.new(finder_params)
      @finder.from ||= Date.today.strftime('%Y-%m-%d')
    end
  
    def finder_params
      if params[:finder].present?
        params.require(:finder).permit(:from)
      else
        {}
      end
    end

  end
end
