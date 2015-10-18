module TaxJp::SocialInsurances::Utils

  def convert_to_prefecture_code(value)
    ret = nil

    if value.is_a?(TaxJp::Prefecture)
      ret = value.code
    elsif value.to_s =~ /[0-9]{2}/
      ret = value.to_s
    else
      p = TaxJp::Prefecture.find_by_name(value.to_s)
      if p
        ret = p.code
      else
        raise TypeError.new(value.class)
      end
    end

    ret
  end

end
