require 'tax_jp/version'
require 'tax_jp/const'

if defined?(Rails)
  require 'tax_jp/rails/engine'
  require 'tax_jp/rails/railtie'
end

module TaxJp
  require 'tax_jp/consumption_tax'
  extend TaxJp::ConsumptionTax

  require 'tax_jp/prefecture'
  extend TaxJp::Prefecture
end
