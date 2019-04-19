require 'test_helper'

class TaxJp::GengouTest < ActiveSupport::TestCase

  def test_令和
    assert_equal '令和元年05月01日', TaxJp::Gengou.to_wareki('2019-05-01')
    assert_equal '01年05月01日', TaxJp::Gengou.to_wareki('2019-05-01', only_date: true)
  end

  def test_平成
    assert_equal '平成元年01月08日', TaxJp::Gengou.to_wareki('1989-01-08')
    assert_equal '01年01月08日', TaxJp::Gengou.to_wareki('1989-01-08', only_date: true)
    assert_equal '平成31年04月30日', TaxJp::Gengou.to_wareki('2019-04-30')
    assert_equal '31年04月30日', TaxJp::Gengou.to_wareki('2019-04-30', only_date: true)
  end

end
