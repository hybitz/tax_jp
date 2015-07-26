# 厚生年金
class TaxJp::SocialInsurances::WelfarePension
  attr_reader :grade
  attr_reader :valid_from, :valid_until
  attr_reader :general, :particular
  attr_reader :child_support

  def initialize(attrs = {})
    @grade = attrs[:grade]
    @valid_from = attrs[:valid_from]
    @valid_until = attrs[:valid_until]
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

  def monthly_standard
    grade.pension_grade > 0 ? grade.monthly_standard : 0
  end

  def floor_amount(amount)
    (amount * 100).floor * 0.01
  end

end
