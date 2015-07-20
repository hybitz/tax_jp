require 'sqlite3'

module TaxJp
  module SocialInsurances
  end

  class SocialInsurance
    DB_PATH = File.join(TaxJp::Utils.data_dir, '社会保険料.db')

    attr_reader :valid_from, :valid_until
    attr_reader :grade, :pension_grade
    attr_reader :monthly_standard, :daily_standard
    attr_reader :salary_from, :salary_to

    def initialize(row)
      @valid_from = row[0]
      @valid_until = row[1]
      @grade = row[2]
      @pension_grade = row[3]
      @monthly_standard = row[4]
      @daily_standard = row[5]
      @salary_from = row[6]
      @salary_to = row[7]
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