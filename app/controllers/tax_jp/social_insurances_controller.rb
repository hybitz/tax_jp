require_dependency "tax_jp/application_controller"

module TaxJp
  class SocialInsurancesController < ApplicationController
    before_action :preload_finder

    def index
      @social_insurances = TaxJp::SocialInsurance.find_all_by_date_and_prefecture(@finder.from, '10')
    end

    private
    
    def preload_finder
      @finder = TaxJp::Finder.new(finder_params)
      @finder.from ||= Date.today.strftime('%Y-%m-%d')
    end
  
    def finder_params
      if params[:finder].present?
        params.require(:finder).permit(:from, :prefecture_code)
      else
        {}
      end
    end

  end
end
