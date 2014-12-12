もし /^(.*?)における、(.*?)円に対する消費税額は、(.*?)円です$/ do |date, amount, tax_amount|
  rate = TaxJp.get_rate_on(date)
  assert_equal tax_amount.to_i, amount.to_i * rate
end
