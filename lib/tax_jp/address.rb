module TaxJp
  module Addresses
  end

  # 減価償却率
  class Address
    DB_PATH = File.join(TaxJp::Utils.data_dir, '住所.db')

    attr_reader :zip_code
    attr_reader :prefecture_code, :prefecture_name

    def initialize(row)
      @zip_code = row[0]
      @prefecture_code = row[1]
      @prefecture_name = row[2]
    end

    def self.find_by_zip_code(zip_code)
      zip_code = TaxJp::Utils.convert_to_zip_code(zip_code)

      TaxJp::Utils.with_database(DB_PATH) do |db|
        sql =  'select zip_code, prefecture_code, prefecture_name from addresses '
        sql << 'where zip_code = ? '

        ret = nil
        db.execute(sql, [zip_code]) do |row|
          ret = TaxJp::Address.new(row)
        end
        ret
      end
    end
  end

end