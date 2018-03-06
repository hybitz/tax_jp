require 'csv'
require 'date'

class TaxJp::LaborInsurances::EmploymentInsuranceDbBuilder < TaxJp::DbBuilder

  def initialize(db_path = nil)
    super(db_path || TaxJp::LaborInsurances::EmploymentInsurance::DB_PATH)
  end

  def run(options = {})
    with_database(options) do |db|
      header = true
      CSV.foreach(File.join(TaxJp::Utils.data_dir, '労働保険', '雇用保険.tsv'), col_sep: "\t", skip_blanks: true) do |row|
        if header
          header = false
          next
        end
        db.execute(insert_sql, row)
      end
    end
  end

  private

  def recreate_schema(db)
    db.execute(TaxJp::Utils.load_file(File.join('労働保険', 'schema_employment_insurances.sql')))
  end

  def insert_sql
    columns = %w{valid_from valid_until employee_general employer_general employee_agric employer_agric employee_const employer_const}

    ret = 'insert into employment_insurances ( '
    ret << columns.join(',')
    ret << ') values ('
    ret << columns.map{|c| '?' }.join(',')
    ret << ')'
    ret
  end
  
end
