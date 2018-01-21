require 'csv'
require 'date'

class TaxJp::CorporateTaxes::DbBuilder

  def initialize(db_path = nil)
    @db_path = db_path || TaxJp::CorporateTax::DB_PATH
  end

  def run(options = {})
    with_database(options) do |db|
      Dir.glob(File.join(TaxJp::Utils.data_dir, '法人税', '区分番号-*.tsv')).each do |filename|
        valid_from, valid_until = TaxJp::Utils.filename_to_date(filename)

        CSV.foreach(filename, :col_sep => "\t", :headers => true) do |row|
          next if row[0].to_s.strip.empty?

          values = []
          values << valid_from
          values << valid_until
          values << row[0].strip
          values << row[1].strip
          values << row[2].strip
          values << row[3].strip
          db.execute(insert_sql_applicable_item, values)
        end
      end
    end
  end

  private

  def with_database(options = {})
    if options.fetch(:recreate, true)
      FileUtils.rm_f(@db_path)
      db = SQLite3::Database.new(@db_path)
      db.execute(TaxJp::Utils.load_file(File.join('法人税', 'schema_applicable_items.sql')))
    else
      db = SQLite3::Database.new(@db_path)
    end

    begin
      yield db
    ensure
      db.close
    end
  end

  def insert_sql_applicable_item
    columns = %w{valid_from valid_until measure_name item_name item_no applicable_to}

    ret = 'insert into applicable_items ( '
    ret << columns.join(',')
    ret << ') values ('
    ret << columns.map{|c| '?' }.join(',')
    ret << ')'
    ret
  end

end
