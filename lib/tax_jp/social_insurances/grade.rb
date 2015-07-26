# 等級
class TaxJp::SocialInsurances::Grade

  attr_reader :valid_from, :valid_until
  attr_reader :grade, :pension_grade
  attr_reader :monthly_standard, :daily_standard
  attr_reader :salary_from, :salary_to

  def initialize(attrs = {})
    @valid_from = attrs[:valid_from]
    @valid_until = attrs[:valid_until]
    @grade = attrs[:grade]
    @pension_grade = attrs[:pension_grade]
    @monthly_standard = attrs[:monthly_standard]
    @daily_standard = attrs[:daily_standard]
    @salary_from = attrs[:salary_from]
    @salary_to = attrs[:salary_to]
  end

end
