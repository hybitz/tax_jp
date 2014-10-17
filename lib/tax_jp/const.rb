module TaxJp
  # 消費税区分
  TAX_TYPES = {
    TAX_TYPE_NONTAXABLE = 1 => '非課税',
    TAX_TYPE_INCLUSIVE = 2 => '内税',
    TAX_TYPE_EXCLUSIVE = 3 => '外税',
  }

  RATE_3 = Date.parse('1989-04-01');
  RATE_5 = Date.parse('1997-04-01');
  RATE_8 = Date.parse('2014-04-01');
end
