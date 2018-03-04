require 'csv'
require 'date'

class TaxJp::SocialInsurances::DbBuilder < TaxJp::DbBuilder

  def initialize(db_path = nil)
    super(db_path || TaxJp::SocialInsurance::DB_PATH)
  end

  def run(options = {})
    with_database(options) do |db|
      Dir.glob(File.join(TaxJp::Utils.data_dir, '社会保険料', '等級-*.tsv')).each do |filename|
        valid_from, valid_until = filename_to_date(filename)

        CSV.foreach(filename, :col_sep => "\t") do |row|
          next if row[0].to_i == 0
          db.execute(insert_sql_grade, [valid_from, valid_until] + row.map{|col| normalize_amount(col)})
        end
      end

      Dir.glob(File.join(TaxJp::Utils.data_dir, '社会保険料', '旧健康保険.tsv')).each do |filename|
        CSV.foreach(filename, :col_sep => "\t") do |row|
          next unless row[2].to_f > 0
          values = []
          values << row[0]
          values << row[1]
          values << nil
          values << (row[2].to_f * 0.01).round(4)
          values << (row[3].to_f * 0.01).round(4)
          values << 0
          values << 0
          db.execute(insert_sql_health_insurance, values)
        end
      end

      Dir.glob(File.join(TaxJp::Utils.data_dir, '社会保険料', '健康保険-*.tsv')).each do |filename|
        valid_from, valid_until = filename_to_date(filename)

        CSV.foreach(filename, :col_sep => "\t") do |row|
          next unless row[1].to_f > 0
          values = []
          values << valid_from
          values << valid_until
          values << TaxJp::Prefecture.find_by_name(row[0]).code
          values << (row[1].to_f * 0.01).round(4)
          values << (row[2].to_f * 0.01).round(4)
          values << (row[3].to_f * 0.01).round(4)
          values << (row[3].to_f * 0.01).round(4)
          db.execute(insert_sql_health_insurance, values)
        end
      end

      Dir.glob(File.join(TaxJp::Utils.data_dir, '社会保険料', '厚生年金.tsv')).each do |filename|
        CSV.foreach(filename, :col_sep => "\t") do |row|
          next unless row[2].to_f > 0
          values = []
          values << row.shift
          values << row.shift
          values += row.map{|col| (col.to_f * 0.01).round(5) }
          db.execute(insert_sql_welfare_pensions, values)
        end
      end

    end
  end

  private

  def recreate_schema
    FileUtils.rm_f(@db_path)
    db = SQLite3::Database.new(@db_path)
    db.execute(TaxJp::Utils.load_file(File.join('社会保険料', 'schema_grades.sql')))
    db.execute(TaxJp::Utils.load_file(File.join('社会保険料', 'schema_health_insurances.sql')))
    db.execute(TaxJp::Utils.load_file(File.join('社会保険料', 'schema_welfare_pensions.sql')))
    db
  end

  def insert_sql_grade
    columns = %w{valid_from valid_until grade pension_grade monthly_standard daily_standard salary_from salary_to}

    ret = 'insert into grades ( '
    ret << columns.join(',')
    ret << ') values ('
    ret << columns.map{|c| '?' }.join(',')
    ret << ')'
    ret
  end

  def insert_sql_health_insurance
    columns = %w{valid_from valid_until prefecture_code general care particular basic}

    ret = 'insert into health_insurances ( '
    ret << columns.join(',')
    ret << ') values ('
    ret << columns.map{|c| '?' }.join(',')
    ret << ')'
    ret
  end

  def insert_sql_welfare_pensions
    columns = %w{valid_from valid_until general particular child_support}

    ret = 'insert into welfare_pensions ( '
    ret << columns.join(',')
    ret << ') values ('
    ret << columns.map{|c| '?' }.join(',')
    ret << ')'
    ret
  end

  def normalize_amount(amount, options = {})
    if amount.to_s == '-'
      ret = 2147483647
    else
      ret = amount.to_s.gsub(',', '').to_i
    end
  end

  def filename_to_date(filename)
    title, valid_from, valid_until = File.basename(filename).split('.').first.split('-')
    valid_from = Date.strptime(valid_from, '%Y%m%d')
    valid_until = Date.strptime(valid_until, '%Y%m%d')
    [valid_from.strftime('%Y-%m-%d'), valid_until.strftime('%Y-%m-%d')]
  end

end
