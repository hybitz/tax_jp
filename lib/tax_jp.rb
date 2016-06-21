require 'sqlite3'
require 'tax_jp/version'
require 'tax_jp/const'

if defined?(Rails)
  require 'tax_jp/rails/engine'
  require 'tax_jp/rails/railtie'
end

require 'tax_jp/utils'
require 'tax_jp/prefecture'

module TaxJp
  # 元号
  require 'tax_jp/gengou'

  # 住所
  require 'tax_jp/address'

  # 消費税
  require 'tax_jp/consumption_tax'
  extend TaxJp::ConsumptionTax

  # 減価償却率
  require 'tax_jp/depreciation_rate'

  # 社会保険料
  require 'tax_jp/social_insurance'

  # 源泉徴収税
  require 'tax_jp/withheld_tax'
end
