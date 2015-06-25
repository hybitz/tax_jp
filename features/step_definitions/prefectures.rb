もし /^JISで定義されているコードは次の通りです。$/ do |ast_table|
  count = 0

  ast_table.raw.each do |row|
    5.times do |i|
      code = row[i*2]
      name = row[i*2+1]
      next if code.empty?
      
      assert p = TaxJp::Prefecture.find_by_code(code)
      assert_equal name, p.name
      
      count += 1
    end
  end

  assert_equal 47, count
end

