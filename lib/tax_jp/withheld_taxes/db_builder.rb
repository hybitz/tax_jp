require 'csv'
require 'date'

class TaxJp::WithheldTaxes::DbBuilder

  def initialize(db_path)
    @db_path = db_path
  end

  def run(options = {})
    db = SQLite3::Database.new(@db_path)

    if options.fetch(:recreate, true)
      db.execute(TaxJp::Utils.load_file(File.join('源泉徴収税', 'schema.sql')))
    end

    Dir.glob(File.join(TaxJp::Utils.data_dir, '源泉徴収税', '*.tsv')).each do |filename|
      valid_from, valid_until = filename_to_date(filename)

      CSV.foreach(filename, :col_sep => "\t") do |row|
        next if row[0].nil?
        db.execute(insert_sql, [valid_from.to_s, valid_until.to_s] + row.map{|col| normalize_amount(col)})
      end
    end

    db.close
  end

  private

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

  def filename_to_date(filename)
    valid_from, valid_until = File.basename(filename).split('.').first.split('-')
    valid_from = Date.strptime(valid_from, '%Y%m%d')
    valid_until = Date.strptime(valid_until, '%Y%m%d')
    [valid_from.to_s, valid_until.to_s]
  end

end
