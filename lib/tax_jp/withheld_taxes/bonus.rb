module TaxJp
  module WithheldTaxes
    
    class Bonus
      DB_PATH = File.join(TaxJp::Utils.data_dir, '源泉徴収税賞与.db')

      attr_reader :valid_from, :valid_until
      attr_reader :tax_ratio
      attr_reader :dependent_0_salary_from, :dependent_0_salary_to
      attr_reader :dependent_1_salary_from, :dependent_1_salary_to
      attr_reader :dependent_2_salary_from, :dependent_2_salary_to
      attr_reader :dependent_3_salary_from, :dependent_3_salary_to
      attr_reader :dependent_4_salary_from, :dependent_4_salary_to
      attr_reader :dependent_5_salary_from, :dependent_5_salary_to
      attr_reader :dependent_6_salary_from, :dependent_6_salary_to
      attr_reader :dependent_7_salary_from, :dependent_7_salary_to
      attr_reader :sub_salary_from, :sub_salary_to

      def initialize(row)
        @valid_from = row[0]
        @valid_until = row[1]
        @tax_ratio = row[2]
        @dependent_0_salary_from = row[3]
        @dependent_0_salary_to = row[4]
        @dependent_1_salary_from = row[5]
        @dependent_1_salary_to = row[6]
        @dependent_2_salary_from = row[7]
        @dependent_2_salary_to = row[8]
        @dependent_3_salary_from = row[9]
        @dependent_3_salary_to = row[10]
        @dependent_4_salary_from = row[11]
        @dependent_4_salary_to = row[12]
        @dependent_5_salary_from = row[13]
        @dependent_5_salary_to = row[14]
        @dependent_6_salary_from = row[15]
        @dependent_6_salary_to = row[16]
        @dependent_7_salary_from = row[17]
        @dependent_7_salary_to = row[18]
        @sub_salary_from = row[19]
        @sub_salary_to = row[20]
      end
    
      def tax_ratio_percent
        (tax_ratio * 100).round(3)
      end

      def self.find_all_by_date(date)
        date = date.strftime('%Y-%m-%d') if date.is_a?(Date)
        TaxJp::Utils.with_database(DB_PATH) do |db|
          sql = 'select * from bonus_withheld_taxes where valid_from <= ? and valid_until >= ? order by tax_ratio'
          
          ret = []
          db.execute(sql, [date, date]) do |row|
            ret << TaxJp::WithheldTaxes::Bonus.new(row)
          end
        
          ret
        end
      end

      def self.find_by_date_and_salary_and_dependant(date, salary, dependent)
        date = date.strftime('%Y-%m-%d') if date.is_a?(Date)
        dependent = dependent.to_i

        TaxJp::Utils.with_database(DB_PATH) do |db|
          sql = String.new("select * from bonus_withheld_taxes ")
          sql << "where valid_from <= ? and valid_until >= ? "
          sql << "  and dependent_#{dependent}_salary_from <= ? and dependent_#{dependent}_salary_to > ?"
          
          ret = nil
          db.execute(sql, [date, date, salary, salary]) do |row|
            ret = TaxJp::WithheldTaxes::Bonus.new(row)
          end
        
          ret
        end
      end

    end
  end
end
