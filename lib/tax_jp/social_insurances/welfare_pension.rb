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
    (monthly_standard * general).round(2) 
  end

  def general_amount_half
    floor_amount(general_amount / 2)
  end

  def particular_amount
    (monthly_standard * particular).round(2) 
  end

  def particular_amount_half
    floor_amount(particular_amount / 2) 
  end

  private

  def monthly_standard
    return 0 if grade.pension_grade == 0
    return 0 if grade.pension_grade > 99
    grade.monthly_standard
  end

  def daily_standard
    return 0 if grade.pension_grade == 0
    return 0 if grade.pension_grade > 99
    grade.daily_standard
  end

  def floor_amount(amount)
    (amount * 100).floor * 0.01
  end

end
