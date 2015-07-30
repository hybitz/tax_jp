require 'sqlite3'

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
      date = convert_to_date(date)
      prefecture_code = convert_to_prefecture_code(prefecture)

      with_database do |db|
        sql =  'select g.*, hi.*, wp.* from grades g '
        sql << 'inner join health_insurances hi on (hi.valid_from <= ? and hi.valid_until >= ? and (hi.prefecture_code = ? or hi.prefecture_code is null)) '
        sql << 'inner join welfare_pensions wp on (wp.valid_from <= ? and wp.valid_until >= ?) '
        sql << 'where g.valid_from <= ? and g.valid_until >= ? '

        ret = []
        db.execute(sql, [date, date, prefecture_code, date, date, date, date]) do |row|
          ret << TaxJp::SocialInsurance.new(row)
        end
        ret
      end
    end

    def self.find_by_date_and_prefecture_and_salary(date, prefecture, salary)
      date = convert_to_date(date)
      prefecture_code = convert_to_prefecture_code(prefecture)
      salary = salary.to_i

      with_database do |db|
        sql =  'select g.*, hi.*, wp.* from grades g '
        sql << 'inner join health_insurances hi on (hi.valid_from <= ? and hi.valid_until >= ? and (hi.prefecture_code = ? or hi.prefecture_code is null)) '
        sql << 'inner join welfare_pensions wp on (wp.valid_from <= ? and wp.valid_until >= ?) '
        sql << 'where g.valid_from <= ? and g.valid_until >= ? and g.salary_from <= ? and g.salary_to > ? '

        ret = nil
        db.execute(sql, [date, date, prefecture_code, date, date, date, date, salary, salary]) do |row|
          ret = TaxJp::SocialInsurance.new(row)
        end
        ret
      end
    end

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