module TaxJp

  # 雇用保険の事業区分
  EMPLOYMENT_INSURANCE_TYPES = {
    EMPLOYMENT_INSURANCE_TYPE_GENERAL = 1 => '一般',
    EMPLOYMENT_INSURANCE_TYPE_AGRIC = 2 => '農林水産・清酒製造',
    EMPLOYMENT_INSURANCE_TYPE_CONST = 3 => '建設'
  }

  # 消費税区分
  TAX_TYPES = {
    TAX_TYPE_NONTAXABLE = 1 => '非課税',
    TAX_TYPE_INCLUSIVE = 2 => '内税',
    TAX_TYPE_EXCLUSIVE = 3 => '外税',
  }

end
