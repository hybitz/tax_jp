require_dependency "tax_jp/application_controller"

module TaxJp
  class SocialInsurancesController < ApplicationController
    before_action :preload_finder

    def index
      if params[:commit]
        @social_insurances = TaxJp::SocialInsurance.find_all_by_date_and_prefecture(@finder.from, @finder.prefecture_code)
      end
    end

    private
    
    def preload_finder
      @finder = TaxJp::Finder.new(finder_params)
      @finder.from ||= Date.today
      @finder.prefecture_code ||= '13' # 人口の多い東京都をデフォルトに
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
