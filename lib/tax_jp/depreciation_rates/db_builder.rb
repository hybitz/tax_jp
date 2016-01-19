require 'csv'

class TaxJp::DepreciationRates::DbBuilder

  def initialize(db_path = nil)
    @db_path = db_path || TaxJp::DepreciationRate::DB_PATH
  end

  def run(options = {})
    with_database(options) do |db|
      Dir.glob(File.join(TaxJp::Utils.data_dir, '減価償却率', '減価償却率-*.tsv')).each do |filename|
        valid_from, valid_until = filename_to_date(filename)

        CSV.foreach(filename, :col_sep => "\t") do |row|
          next if row[0].to_i == 0
          db.execute(insert_sql, [valid_from, valid_until] + row)
        end
      end
    end
  end

  private

  def with_database(options = {})
    if options.fetch(:recreate, true)
      FileUtils.rm_f(@db_path)
      db = SQLite3::Database.new(@db_path)
      db.execute(TaxJp::Utils.load_file(File.join('減価償却率', 'schema_depreciation_rates.sql')))
    else
      db = SQLite3::Database.new(@db_path)
    end

    begin
      yield db
    ensure
      db.close
    end
  end

  def insert_sql
    columns = %w{valid_from valid_until durable_years fixed_amount_rate rate revised_rate guaranteed_rate}

    ret = 'insert into depreciation_rates ( '
    ret << columns.join(',')
    ret << ') values ('
    ret << columns.map{|c| '?' }.join(',')
    ret << ')'
    ret
  end

  def filename_to_date(filename)
    title, valid_from, valid_until = File.basename(filename).split('.').first.split('-')
    valid_from = Date.strptime(valid_from, '%Y%m%d')
    valid_until = Date.strptime(valid_until, '%Y%m%d')
    [valid_from.strftime('%Y-%m-%d'), valid_until.strftime('%Y-%m-%d')]
  end

end
