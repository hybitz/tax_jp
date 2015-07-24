require 'sqlite3'
require_relative 'welfare_pension'

module TaxJp
  module SocialInsurances
  end

  # 社会保険
  class SocialInsurance
    DB_PATH = File.join(TaxJp::Utils.data_dir, '社会保険料.db')

    # 等級
    attr_reader :valid_from, :valid_until
    attr_reader :grade, :pension_grade
    attr_reader :monthly_standard, :daily_standard
    attr_reader :salary_from, :salary_to

    # 健康保険
    attr_reader :si_valid_from, :si_valid_until
    attr_reader :prefecture
    attr_reader :general, :particular, :basic

    # 厚生年金
    attr_reader :welfare_pension

    def initialize(row)
      @valid_from = row[0]
      @valid_until = row[1]
      @grade = row[2]
      @pension_grade = row[3]
      @monthly_standard = row[4]
      @daily_standard = row[5]
      @salary_from = row[6]
      @salary_to = row[7]
      @si_valid_from = row[8]
      @si_valid_until = row[9]
      @prefecture = Prefecture.find_by_code(row[10])
      @general = row[11]
      @particular = row[12]
      @basic = row[13]
      @welfare_pension = TaxJp::WelfarePension.new(
        :valid_from => row[14], :valid_until => row[15],
        :monthly_standard => row[4],
        :general => row[16], :particular => row[17],
        :child_support => row[18])
    end

    def general_amount
      floor_amount(monthly_standard * general) 
    end

    def general_amount_half
      general_amount / 2
    end

    def general_amount_care
      floor_amount(monthly_standard * (general + 0.0158)) 
    end

    def general_amount_care_half
      general_amount_care / 2
    end

    private

    def floor_amount(amount)
      (amount * 10).floor * 0.1
    end

    def self.find_grade_by_date_and_salary(date, salary)
      date = date.strftime('%Y-%m-%d') if date.is_a?(Date)

      with_database do |db|
        sql = 'select * from grades where valid_from <= ? and valid_until >= ? and salary_from <= ? and salary_to > ?'

        ret = nil
        db.execute(sql, [date, date, salary, salary]) do |row|
          if ret
            raise "等級が重複して登録されています。date=#{date}, salary=#{salary}"
          else
            ret = TaxJp::SocialInsurance.new(row)
          end
        end
        ret
      end
    end

    def self.find_grades_by_date(date)
      date = date.strftime('%Y-%m-%d') if date.is_a?(Date)

      with_database do |db|
        sql = 'select * from grades where valid_from <= ? and valid_until >= ?'
        
        ret = []
        db.execute(sql, [date, date]) do |row|
          ret << TaxJp::SocialInsurance.new(row)
        end
        
        ret.sort{|a, b| a.grade <=> b.grade }
      end
    end

    def self.find_by_date_and_prefecture_and_grade(date, prefecture, grade)
      if date.is_a?(Date)
        date = date.strftime('%Y-%m-%d')
      elsif date.is_a?(String)
      else
        raise TypeError.new(date.class)
      end

      if prefecture.is_a?(TaxJp::Prefecture)
        prefecture_code = prefecture.code
      elsif prefecture.to_s =~ /[0-9]{2}/
        prefecture_code = prefecture
      else
        p = Prefecture.find_by_name(prefecture.to_s)
        if p
          prefecture_code = p.code
        else
          raise TypeError.new(prefecture.class)
        end
      end

      if grade.is_a?(TaxJp::SocialInsurance)
        grade = grade.grade
      elsif grade.is_a?(Fixnum)
        grade = grade.to_i
      else
        raise TypeError.new("#{grade.class} は等級として不正です。")
      end

      with_database do |db|
        sql =  'select g.*, hi.*, wp.* from grades g '
        sql << 'inner join health_insurances hi on (hi.valid_from <= ? and hi.valid_until >= ? and hi.prefecture_code = ?) '
        sql << 'inner join welfare_pensions wp on (wp.valid_from <= ? and wp.valid_until >= ?) '
        sql << 'where g.valid_from <= ? and g.valid_until >= ? and g.grade = ? '

        ret = nil
        db.execute(sql, [date, date, prefecture_code, date, date, date, date, grade]) do |row|
          if ret
            raise "健康保険が重複して登録されています。date=#{date}, prefecture_code=#{prefecture_code}, grade=#{grade}"
          else
            ret = TaxJp::SocialInsurance.new(row)
          end
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