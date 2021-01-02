# 健康保健
class TaxJp::SocialInsurances::HealthInsurance
  attr_reader :grade
  attr_reader :valid_from, :valid_until
  attr_reader :prefecture
  attr_reader :general, :care
  attr_reader :particular, :basic
  
  attr_writer :salary

  def initialize(attrs)
    @salary = nil

    if attrs.is_a?(Hash)
      @grade = attrs[:grade]
      @valid_from = attrs[:valid_from]
      @valid_until = attrs[:valid_until]
      @prefecture = attrs[:prefecture]
      @general= attrs[:general]
      @care = attrs[:care]
      @particular= attrs[:particular]
      @basic = attrs[:basic]
    elsif attrs.is_a?(Array)
      @valid_from = attrs[0]
      @valid_until = attrs[1]
      @prefecture = attrs[2]
      @general= attrs[3]
      @care = attrs[4]
      @particular= attrs[5]
      @basic = attrs[6]
    end
  end

  def general_amount
    (salary * general).round(1)
  end

  def general_amount_half
    (general_amount / 2).floor(1)
  end

  def general_amount_care
    (salary * (general + care)).round(1) 
  end

  def general_amount_care_half
    (general_amount_care / 2).floor(1) 
  end

  def salary
    @salary || monthly_standard
  end

  private

  def monthly_standard
    raise '等級が指定されていません' unless grade
    grade.grade > 0 ? grade.monthly_standard : 0
  end

end
