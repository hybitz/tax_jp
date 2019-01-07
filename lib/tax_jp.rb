require 'sqlite3'
require "tax_jp/engine"
require 'tax_jp/const'
require 'tax_jp/utils'
require 'tax_jp/prefecture'

module TaxJp
  # 元号
  require 'tax_jp/gengou'

  # 住所
  require 'tax_jp/address'

  # 消費税
  require 'tax_jp/consumption_tax'

  # 法人税-区分番号
  require 'tax_jp/corporate_tax'

  # 減価償却率
  require 'tax_jp/depreciation_rate'

  # 社会保険
  require 'tax_jp/social_insurance'

  # 労働保険
  require 'tax_jp/labor_insurance'

  # 源泉徴収税
  require 'tax_jp/withheld_tax'
end
