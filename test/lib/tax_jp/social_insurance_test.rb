require 'test_helper'

class TaxJp::SocialInsuranceTest < ActiveSupport::TestCase

  def test_2020年09月以降の最大等級
    assert_equal 31, TaxJp::SocialInsurance::find_max_pension_grade_by_date(Date.new(2020, 8, 31)).pension_grade
    assert_equal 32, TaxJp::SocialInsurance::find_max_pension_grade_by_date(Date.new(2020, 9, 1)).pension_grade
  end

  def test_2020年09月以降の等級32の厚生年金
    prefecture = TaxJp::Prefecture.find_by_name('東京都')
    salary = 635_000

    si = TaxJp::SocialInsurance.find_by_date_and_prefecture_and_salary(Date.new(2020, 8, 31), prefecture, salary)
    assert_equal 31, si.welfare_pension.grade.pension_grade
    assert_equal 56_730.00, si.welfare_pension.general_amount_half

    si = TaxJp::SocialInsurance.find_by_date_and_prefecture_and_salary(Date.new(2020, 9, 1), prefecture, salary)
    assert_equal 32, si.welfare_pension.grade.pension_grade
    assert_equal 59_475.00, si.welfare_pension.general_amount_half
  end

end
