# 厚生年金
class TaxJp::SocialInsurances::WelfarePension
  attr_reader :valid_from, :valid_until
  attr_reader :general, :particular
  attr_reader :child_support

  attr_accessor :grade
  attr_writer :salary

  def initialize(attrs)
    @salary = nil

    if attrs.is_a?(Hash)
      @grade = attrs[:grade]
      @valid_from = attrs[:valid_from]
      @valid_until = attrs[:valid_until]
      @general= attrs[:general]
      @particular= attrs[:particular]
      @child_support = attrs[:child_support]
    elsif attrs.is_a?(Array)
      @valid_from = attrs[0]
      @valid_until = attrs[1]
      @general= attrs[2]
      @particular= attrs[3]
      @child_support = attrs[4]
    end
  end

  def general_amount
    (salary * general).round(2) 
  end

  def general_amount_half
    (general_amount / 2).floor(2)
  end

  def particular_amount
    (salary * particular).round(2) 
  end

  def particular_amount_half
    (particular_amount / 2).floor(2) 
  end
  
  def salary
    @salary || monthly_standard
  end

  private

  def monthly_standard
    raise '等級が指定されていません' unless grade
    return 0 if grade.pension_grade == 0
    grade.monthly_standard
  end

  def daily_standard
    raise '等級が指定されていません' unless grade
    return 0 if grade.pension_grade == 0
    grade.daily_standard
  end

end
