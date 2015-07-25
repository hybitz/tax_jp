module TaxJp

  # 健康年金
  class HealthInsurance
    attr_reader :valid_from, :valid_until
    attr_reader :monthly_standard
    attr_reader :prefecture
    attr_reader :general, :care
    attr_reader :particular, :basic

    def initialize(attrs = {})
      @valid_from = attrs[:valid_from]
      @valid_until = attrs[:valid_until]
      @monthly_standard = attrs[:monthly_standard]
      @prefecture = attrs[:prefecture]
      @general= attrs[:general]
      @care = attrs[:care]
      @particular= attrs[:particular]
      @basic = attrs[:basic]
    end

    def general_amount
      floor_amount(monthly_standard * general) 
    end

    def general_amount_half
      floor_amount(monthly_standard * general / 2) 
    end

    def general_amount_care
      floor_amount(monthly_standard * (general + care)) 
    end

    def general_amount_care_half
      floor_amount(monthly_standard * (general + care) / 2) 
    end

    private

    def floor_amount(amount)
      (amount * 10).floor * 0.1
    end

  end

end
