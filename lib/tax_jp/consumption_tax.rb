module TaxJp
  module ConsumptionTax
    @@consumption_taxes = TaxJp::Utils.load_yaml('消費税.yml')

    def rate_on(date, options = {})
      if date.is_a?(String)
        date = Date.parse(date)
      end

      ret = 0
      @@consumption_taxes.reverse_each do |start_date, rate|
        ret = rate
        break if date >= start_date
      end
  
      if options[:percent]
        ret *= 100
      end
      
      ret
    end

  end
end