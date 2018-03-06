# 雇用保健
class TaxJp::LaborInsurances::EmploymentInsurance
  DB_PATH = File.join(TaxJp::Utils.data_dir, '雇用保険料.db')

  attr_reader :valid_from        # 適用開始日
  attr_reader :valid_until       # 適用終了日
  attr_reader :employee_general  # 労働者負担（一般）
  attr_reader :employer_general  # 事業主負担（一般）
  attr_reader :employee_agric    # 労働者負担（農林水産・清酒製造）
  attr_reader :employer_agric    # 事業主負担（農林水産・清酒製造）
  attr_reader :employee_const    # 労働者負担（建設）
  attr_reader :employer_const    # 事業主負担（建設）

  def initialize(row)
    @valid_from = row[0]
    @valid_until = row[1]
    @employee_general = row[2]
    @employer_general = row[3]
    @employee_agric = row[4]
    @employer_agric = row[5]
    @employee_const = row[6]
    @employer_const = row[7]
  end

  def self.find_all
    TaxJp::Utils.with_database(DB_PATH) do |db|
      sql = 'select * from employment_insurances order by valid_from desc'
  
      ret = []
      db.execute(sql) do |row|
        ret << self.new(row)
      end
      ret
    end
  end

  def self.find_by_date(date)
    date = TaxJp::Utils.convert_to_date(date)

    TaxJp::Utils.with_database(DB_PATH) do |db|
      sql = 'select * from employment_insurances where valid_from <= ? and valid_until >= ?'

      ret = nil
      db.execute(sql, [date, date]) do |row|
        if ret
          raise "雇用保険料が重複して登録されています。date=#{date}"
        else
          ret = self.new(row)
        end
      end
      ret
    end
  end

end
