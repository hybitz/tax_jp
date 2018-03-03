require 'csv'
require 'date'

class TaxJp::LaborInsurances::EmploymentInsuranceDbBuilder

  def initialize(db_path = nil)
    @db_path = db_path || TaxJp::LaborInsurances::EmploymentInsurance::DB_PATH
  end


end
