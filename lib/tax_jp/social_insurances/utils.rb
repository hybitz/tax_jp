module TaxJp::SocialInsurances::Utils

  def convert_to_date(value)
    ret = nil

    if value.is_a?(Date)
      ret = value.strftime('%Y-%m-%d')
    elsif value.is_a?(String)
      ret = value
    else
      raise TypeError.new(value.class)
    end

    ret
  end

  def convert_to_prefecture_code(value)
    ret = nil

    if value.is_a?(TaxJp::Prefecture)
      ret = value.code
    elsif value.to_s =~ /[0-9]{2}/
      ret = value.to_s
    else
      p = Prefecture.find_by_name(value.to_s)
      if p
        ret = p.code
      else
        raise TypeError.new(value.class)
      end
    end

    ret
  end

end
