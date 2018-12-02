require 'csv'
require 'date'

class TaxJp::WithheldTaxes::MonthlyDbBuilder < TaxJp::DbBuilder

  def initialize(db_path = nil)
    @db_path = db_path || TaxJp::WithheldTax::MONTHLY_DB_PATH
  end

  def run(options = {})
    with_database(options) do |db|
      Dir.glob(File.join(TaxJp::Utils.data_dir, '源泉徴収税', '源泉徴収税月額-*.tsv')).each do |filename|
        valid_from, valid_until = TaxJp::Utils.filename_to_date(filename)
  
        CSV.foreach(filename, :col_sep => "\t") do |row|
          next if row[0].to_i == 0
          db.execute(insert_sql, [valid_from.to_s, valid_until.to_s] + row.map{|col| normalize_amount(col)})
        end
      end
    end
  end

  private

  def recreate_schema(db)
    db.execute(TaxJp::Utils.load_file(File.join('源泉徴収税', 'schema_monthly.sql')))
  end

  def insert_sql
    ret = 'insert into withheld_taxes (valid_from, valid_until, salary_range_from, salary_range_to, '
    8.times do |i|
      ret << "dependent_#{i}, "
    end
    ret << 'sub_salary) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
    ret
  end

  def normalize_amount(amount)
    amount.to_s.gsub(',', '').to_i
  end

end
