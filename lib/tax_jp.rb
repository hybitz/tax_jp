require 'tax_jp/version'
require 'tax_jp/const'

if defined?(Rails)
  require 'tax_jp/rails/engine'
  require 'tax_jp/rails/railtie'
end

require 'tax_jp/utils'
require 'tax_jp/prefecture'

module TaxJp
  require 'tax_jp/consumption_tax'
  extend TaxJp::ConsumptionTax
end
