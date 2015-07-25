module TaxJp

  # 厚生年金
  class WelfarePension
    attr_reader :valid_from, :valid_until
    attr_reader :monthly_standard
    attr_reader :general, :particular
    attr_reader :child_support

    def initialize(attrs = {})
      @valid_from = attrs[:valid_from]
      @valid_until = attrs[:valid_until]
      @monthly_standard = attrs[:monthly_standard]
      @general= attrs[:general]
      @particular= attrs[:particular]
      @child_support = attrs[:child_support]
    end

    def general_amount
      floor_amount(monthly_standard * general) 
    end

    def general_amount_half
      floor_amount(monthly_standard * general / 2) 
    end

    def particular_amount
      floor_amount(monthly_standard * particular) 
    end

    def particular_amount_half
      floor_amount(monthly_standard * particular / 2) 
    end

    private

    def floor_amount(amount)
      (amount * 100).floor * 0.01
    end

  end

end
