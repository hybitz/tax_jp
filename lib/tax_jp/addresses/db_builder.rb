require 'csv'

class TaxJp::Addresses::DbBuilder

  def initialize(db_path = nil)
    @db_path = db_path || TaxJp::Address::DB_PATH
  end

  def run(options = {})
    with_database(options) do |db|
      puts
      prefecture_code = nil
      CSV.foreach(File.join('data', '住所', 'addresses.csv')) do |line|
        if prefecture_code != line[0][0..1]
          prefecture_code = line[0][0..1]
          puts prefecture_code
        end

        zip_code = line[2]
        prefecture_name = line[6]
        city = line[7]
        section = line[8] == '以下に掲載がない場合' ? '' : line[8]

        section = section.gsub(/（.*/, '')
        if section.end_with?('地割）') or section.end_with?('地割')
          next
        end

        row = [zip_code, prefecture_code, prefecture_name, city, section]
        db.execute(insert_sql, row)
      end
      puts
    end
  end

  private

  def with_database(options = {})
    if options.fetch(:recreate, true)
      FileUtils.rm_f(@db_path)
      db = SQLite3::Database.new(@db_path)
      db.execute(TaxJp::Utils.load_file(File.join('住所', 'schema_addresses.sql')))
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
    columns = %w{zip_code prefecture_code prefecture_name city section}

    ret = 'insert into addresses ( '
    ret << columns.join(',')
    ret << ') values ('
    ret << columns.map{|c| '?' }.join(',')
    ret << ')'
    ret
  end
end
