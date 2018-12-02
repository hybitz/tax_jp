module TaxJp
  module WithheldTaxes
  end

  class WithheldTax
    MONTHLY_DB_PATH = File.join(TaxJp::Utils.data_dir, '源泉徴収税月額.db')

    attr_reader :valid_from, :valid_until
    attr_reader :salary_range_from, :salary_range_to
    attr_reader :dependent_0, :dependent_1, :dependent_2, :dependent_3, :dependent_4, :dependent_5, :dependent_6, :dependent_7
    attr_reader :sub_salary

    def initialize(row)
      @valid_from = row[0]
      @valid_until = row[1]
      @salary_range_from = row[2]
      @salary_range_to = row[3]
      @dependent_0 = row[4]
      @dependent_1 = row[5]
      @dependent_2 = row[6]
      @dependent_3 = row[7]
      @dependent_4 = row[8]
      @dependent_5 = row[9]
      @dependent_6 = row[10]
      @dependent_7 = row[11]
      @sub_salary = row[12]
    end

    def self.find_by_date_and_salary(date, salary)
      date = date.strftime('%Y-%m-%d') if date.is_a?(Date)
      TaxJp::Utils.with_database(MONTHLY_DB_PATH) do |db|
        sql = 'select * from withheld_taxes where valid_from <= ? and valid_until >= ? and salary_range_from <= ? and salary_range_to > ?'

        ret = nil
        db.execute(sql, [date, date, salary, salary]) do |row|
          if ret
            raise "源泉徴収税が重複して登録されています。date=#{date}, salary=#{salary}"
          else
            ret = TaxJp::WithheldTax.new(row)
          end
        end
        ret
      end
    end

    def self.find_all_by_date(date)
      date = date.strftime('%Y-%m-%d') if date.is_a?(Date)
      TaxJp::Utils.with_database(MONTHLY_DB_PATH) do |db|
        sql = 'select * from withheld_taxes where valid_from <= ? and valid_until >= ?'
        
        ret = []
        db.execute(sql, [date, date]) do |row|
          ret << TaxJp::WithheldTax.new(row)
        end
        
        ret.sort{|a, b| a.salary_range_from <=> b.salary_range_from }
      end
    end

  end
end
