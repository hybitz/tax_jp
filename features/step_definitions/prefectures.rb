もし /^JISで定義されているコードは以下の通りです。$/ do |ast_table|
  assert rows = ast_table.raw
  assert_equal 47, rows.size

  rows.each do |row|
    code = row[0]
    name = row[1]
    assert p = TaxJp::Prefecture.find_by_code(code)
    assert_equal name, p.name
  end
end

