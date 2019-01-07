module TaxJp
  module ConsumptionTaxes
  end
  
  class ConsumptionTax
    @@consumption_taxes = TaxJp::Utils.load_yaml('消費税.yml')

    attr_reader :valid_from
    attr_reader :national, :local, :total

    def initialize(valid_from, values)
      @valid_from = valid_from
      @national = values['national']
      @local = values['local']
      @total = values['total']
    end

    def self.all
      ret = []
      @@consumption_taxes.each do |valid_from, values|
        ret << ConsumptionTax.new(valid_from, values)
      end
      ret
    end

    def self.rate_on(date, options = {})
      if date.is_a?(String)
        date = Date.parse(date)
      end

      ret = 0
      @@consumption_taxes.reverse_each do |valid_from, rate|
        ret = rate['total']
        break if date >= valid_from
      end

      if options[:percent]
        ret *= 100
      end

      ret
    end

    def national_percent
      national * 100
    end

    def local_percent
      local * 100
    end

    def total_percent
      total * 100
    end

  end
end