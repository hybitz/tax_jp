もし /^JISで定義されているコードは以下の通りです。$/ do |ast_table|
  assert rows = ast_table.raw
  assert_equal 47, rows.size

  rows.each do |row|
    code = row[0]
    name = row[1]
    assert_equal name, TaxJp.find_prefecture_by_code(code)
  end
end

