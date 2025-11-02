module TaxJp
  module SocialInsurances
    require_relative 'social_insurances/utils'
    require_relative 'social_insurances/grade'
    require_relative 'social_insurances/health_insurance'
    require_relative 'social_insurances/welfare_pension'
  end

  # 社会保険
  class SocialInsurance
    extend TaxJp::SocialInsurances::Utils

    DB_PATH = File.join(TaxJp::Utils.data_dir, '社会保険料.db')

    # 等級
    attr_reader :grade
    # 健康保険
    attr_reader :health_insurance
    # 厚生年金
    attr_reader :welfare_pension

    def initialize(row)
      @grade = TaxJp::SocialInsurances::Grade.new(
        :valid_from => row[0], :valid_until => row[1],
        :grade => row[2], :pension_grade => row[3],
        :monthly_standard => row[4], :daily_standard => row[5],
        :salary_from => row[6], :salary_to => row[7])

      @health_insurance = TaxJp::SocialInsurances::HealthInsurance.new(
        :grade => @grade,
        :valid_from => row[8], :valid_until => row[9],
        :prefecture => Prefecture.find_by_code(row[10]),
        :general => row[11], :care => row[12],
        :particular => row[13], :basic => row[14])

      @welfare_pension = TaxJp::SocialInsurances::WelfarePension.new(
        :grade => @grade,
        :valid_from => row[15], :valid_until => row[16],
        :general => row[17], :particular => row[18],
        :child_support => row[19])
    end

    def valid_from
      ret = grade.valid_from
      if health_insurance and health_insurance.valid_from > ret
        ret = health_insurance.valid_from
      end
      if welfare_pension and welfare_pension.valid_from > ret
        ret = welfare_pension.valid_from
      end
      ret
    end

    def valid_until
      ret = grade.valid_until
      if health_insurance and health_insurance.valid_until < ret
        ret = health_insurance.valid_until
      end
      if welfare_pension and welfare_pension.valid_until < ret
        ret = welfare_pension.valid_until
      end
      ret
    end

    def self.find_all_by_date_and_prefecture(date, prefecture)
      date = TaxJp::Utils.convert_to_date(date)
      prefecture_code = convert_to_prefecture_code(prefecture)

      TaxJp::Utils.with_database(DB_PATH) do |db|
        sql, params = base_query(date, prefecture_code)

        sql << 'where g.valid_from <= ? and g.valid_until >= ? '
        params += [date, date]

        ret = []
        db.execute(sql, params) do |row|
          ret << TaxJp::SocialInsurance.new(row)
        end
        ret
      end
    end

    def self.find_by_date_and_prefecture_and_salary(date, prefecture, salary)
      date = TaxJp::Utils.convert_to_date(date)
      prefecture_code = convert_to_prefecture_code(prefecture)
      salary = salary.to_i

      TaxJp::Utils.with_database(DB_PATH) do |db|
        sql, params = base_query(date, prefecture_code)

        sql << 'where g.valid_from <= ? and g.valid_until >= ? and g.salary_from <= ? and g.salary_to > ? '
        params += [date, date, salary, salary]

        row = db.execute(sql, params).first
        ret = TaxJp::SocialInsurance.new(row)

        if ret.welfare_pension.grade.pension_grade == TaxJp::INTEGER_MAX
          ret.welfare_pension.grade = find_max_pension_grade_by_date(date)
        end

        ret
      end
    end

    def self.find_by_date_and_prefecture_and_pension_grade(date, prefecture, pension_grade)
      date = TaxJp::Utils.convert_to_date(date)
      prefecture_code = convert_to_prefecture_code(prefecture)

      TaxJp::Utils.with_database(DB_PATH) do |db|
        sql, params = base_query(date, prefecture_code)

        sql << 'where g.valid_from <= ? and g.valid_until >= ? and g.pension_grade = ? '
        params += [date, date, pension_grade]

        ret = nil
        db.execute(sql, params) do |row|
          ret = TaxJp::SocialInsurance.new(row)
        end
        ret
      end
    end

    def self.find_health_insurance_by_date_and_prefecture_and_salary(date, prefecture, salary)
      date = TaxJp::Utils.convert_to_date(date)
      prefecture_code = convert_to_prefecture_code(prefecture)

      TaxJp::Utils.with_database(DB_PATH) do |db|
        sql =  String.new('select * from health_insurances ')
        sql << 'where valid_from <= ? and valid_until >= ? and (prefecture_code = ? or prefecture_code is null) ' 
        params = [date, date, prefecture_code]

        ret = nil
        db.execute(sql, params) do |row|
          ret = TaxJp::SocialInsurances::HealthInsurance.new(row)
          ret.salary = salary
        end
        ret
      end
    end

    def self.find_max_pension_grade_by_date(date)
      date = TaxJp::Utils.convert_to_date(date)

      TaxJp::Utils.with_database(DB_PATH, results_as_hash: true) do |db|
        sql =  String.new('select * from grades ')
        sql << 'where valid_from <= ? and valid_until >= ? and pension_grade = ( '
        sql << '  select max(pension_grade) from grades '
        sql << '  where valid_from <= ? and valid_until >= ? and pension_grade < ? ' 
        sql << ') '
        params = [date, date, date, date, TaxJp::INTEGER_MAX]

        row = db.execute(sql, params).first.with_indifferent_access
        TaxJp::SocialInsurances::Grade.new(row)
      end
    end

    def self.find_welfare_pension_by_date_and_salary(date, salary)
      date = TaxJp::Utils.convert_to_date(date)

      TaxJp::Utils.with_database(DB_PATH) do |db|
        sql =  String.new('select * from welfare_pensions ')
        sql << 'where valid_from <= ? and valid_until >= ? ' 
        params = [date, date]

        ret = nil
        db.execute(sql, params) do |row|
          ret = TaxJp::SocialInsurances::WelfarePension.new(row)
          ret.salary = salary
        end
        ret
      end
    end

    def self.base_query(date, prefecture_code)
      sql =  String.new('select g.*, hi.*, wp.* from grades g ')
      sql << 'inner join health_insurances hi on (hi.valid_from <= ? and hi.valid_until >= ? and (hi.prefecture_code = ? or hi.prefecture_code is null)) '
      sql << 'inner join welfare_pensions wp on (wp.valid_from <= ? and wp.valid_until >= ?) '

      params = [date, date, prefecture_code, date, date]

      return sql, params
    end
    private_class_method :base_query

  end

end