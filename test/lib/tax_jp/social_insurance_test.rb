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

  def test_2026年03月分の健康保険料月額表_東京都_等級1
    prefecture = TaxJp::Prefecture.find_by_name('東京都')
    list = TaxJp::SocialInsurance.find_all_by_date_and_prefecture(Date.new(2026, 3, 1), prefecture)
    si = list.find { |r| r.grade.grade == 1 }
    assert si

    assert_equal 5713.0, si.health_insurance.general_amount
    assert_equal 2856.5, si.health_insurance.general_amount_half
    assert_equal 6652.6, si.health_insurance.general_amount_care
    assert_equal 3326.3, si.health_insurance.general_amount_care_half
  end

  def test_2026年03月分の健康保険料月額表_東京都_等級10
    prefecture = TaxJp::Prefecture.find_by_name('東京都')
    list = TaxJp::SocialInsurance.find_all_by_date_and_prefecture(Date.new(2026, 3, 1), prefecture)
    si = list.find { |r| r.grade.grade == 10 }
    assert si

    assert_equal 13199.0, si.health_insurance.general_amount
    assert_equal 6599.5, si.health_insurance.general_amount_half
    assert_equal 15369.8, si.health_insurance.general_amount_care
    assert_equal 7684.9, si.health_insurance.general_amount_care_half
  end

  def test_2026年03月分の健康保険料月額表_東京都_等級20
    prefecture = TaxJp::Prefecture.find_by_name('東京都')
    list = TaxJp::SocialInsurance.find_all_by_date_and_prefecture(Date.new(2026, 3, 1), prefecture)
    si = list.find { |r| r.grade.grade == 20 }
    assert si

    assert_equal 25610.0, si.health_insurance.general_amount
    assert_equal 12805.0, si.health_insurance.general_amount_half
    assert_equal 29822.0, si.health_insurance.general_amount_care
    assert_equal 14911.0, si.health_insurance.general_amount_care_half
  end

  def test_2026年03月分の健康保険料月額表_北海道_等級1
    prefecture = TaxJp::Prefecture.find_by_name('北海道')
    list = TaxJp::SocialInsurance.find_all_by_date_and_prefecture(Date.new(2026, 3, 1), prefecture)
    si = list.find { |r| r.grade.grade == 1 }
    assert si

    assert_equal 5962.4, si.health_insurance.general_amount
    assert_equal 2981.2, si.health_insurance.general_amount_half
    assert_equal 6902.0, si.health_insurance.general_amount_care
    assert_equal 3451.0, si.health_insurance.general_amount_care_half
  end

  def test_2026年03月分の健康保険料月額表_大阪府_等級10
    prefecture = TaxJp::Prefecture.find_by_name('大阪府')
    list = TaxJp::SocialInsurance.find_all_by_date_and_prefecture(Date.new(2026, 3, 1), prefecture)
    si = list.find { |r| r.grade.grade == 10 }
    assert si

    assert_equal 13574.2, si.health_insurance.general_amount
    assert_equal 6787.1, si.health_insurance.general_amount_half
    assert_equal 15745.0, si.health_insurance.general_amount_care
    assert_equal 7872.5, si.health_insurance.general_amount_care_half
  end

end
