module TaxJp
  module DepreciationRates
  end

  # 減価償却率
  class DepreciationRate
    DB_PATH = File.join(TaxJp::Utils.data_dir, '減価償却率.db')

    attr_reader :valid_from, :valid_until
    attr_reader :durable_years
    attr_reader :fixed_amount_rate
    attr_reader :rate, :revised_rate, :guaranteed_rate

    def initialize(row)
      @valid_from = row[0]
      @valid_until = row[1]
      @durable_years = row[2]
      @fixed_amount_rate = row[3]
      @rate = row[4]
      @revised_rate = row[5]
      @guaranteed_rate = row[6]
    end

    def self.find_all_by_date(date)
      date = TaxJp::Utils.convert_to_date(date)

      with_database do |db|
        sql =  String.new('select * from depreciation_rates ')
        sql << 'where valid_from <= ? and valid_until >= ? '
        sql << 'order by durable_years '

        ret = []
        db.execute(sql, [date, date]) do |row|
          ret << TaxJp::DepreciationRate.new(row)
        end
        ret
      end
    end

    def self.find_by_date_and_durable_years(date, durable_years)
      date = TaxJp::Utils.convert_to_date(date)

      with_database do |db|
        sql =  String.new('select * from depreciation_rates ')
        sql << 'where valid_from <= ? and valid_until >= ? '
        sql << '  and durable_years = ? '

        ret = nil
        db.execute(sql, [date, date, durable_years]) do |row|
          ret = TaxJp::DepreciationRate.new(row)
        end
        ret
      end
    end

    private

    def self.with_database
      db = SQLite3::Database.new(DB_PATH)
      begin
        yield db
      ensure
        db.close
      end
    end
  end

end