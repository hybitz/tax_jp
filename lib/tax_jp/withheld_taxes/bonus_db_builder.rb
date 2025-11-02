require 'csv'
require 'date'

class TaxJp::WithheldTaxes::BonusDbBuilder < TaxJp::DbBuilder

  def initialize(db_path = nil)
    @db_path = db_path || TaxJp::WithheldTaxes::Bonus::DB_PATH
  end

  def run(options = {})
    with_database(options) do |db|
      Dir.glob(File.join(TaxJp::Utils.data_dir, '源泉徴収税', '源泉徴収税賞与-*.tsv')).each do |filename|
        valid_from, valid_until = TaxJp::Utils.filename_to_date(filename)
  
        CSV.foreach(filename, col_sep: "\t") do |row|
          next if row[1].to_i == 0 && row[2].to_i == 0
          values = row.map{|col| TaxJp::Utils.normalize_amount(col)}
          ratio = values.shift / 100
          values = values.map{|value| value < TaxJp::INTEGER_MAX ? value * 1000 : value }
          db.execute(insert_sql, [valid_from.to_s, valid_until.to_s, ratio] + values)
        end
      end
    end
  end

  private

  def recreate_schema(db)
    db.execute(TaxJp::Utils.load_file(File.join('源泉徴収税', 'schema_bonus.sql')))
  end

  def insert_sql
    ret = String.new('insert into bonus_withheld_taxes (valid_from, valid_until, tax_ratio, ')
    8.times do |i|
      ret << "dependent_#{i}_salary_from, dependent_#{i}_salary_to, "
    end
    ret << 'sub_salary_from, sub_salary_to) values (?, ?, ?, '
    ret << '?, ' * 16
    ret << '?, ?)'
    ret
  end

end
