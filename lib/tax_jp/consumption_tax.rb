module TaxJp
  module ConsumptionTax
  
    def get_rate_on(date, options = {})
      if (date.is_a?(String))
        date = Date.parse(date)
      end
  
      if (date >= RATE_3 && date < RATE_5)
        ret = 0.03;
      elsif (date >= RATE_5 && date < RATE_8)
        ret = 0.05;
      elsif (date >= RATE_8)
        ret = 0.08;
      else
        ret = 0
      end
  
      if options[:percent]
        ret *= 100
      end
      
      ret
    end

  end
end