require 'yaml'

module TaxJp
  class Gengou
    @@_gengou = TaxJp::Utils.load_yaml('元号.yml')
  
    def self.to_seireki(gengou, year_jp)
      target_gengou = nil
      @@_gengou.invert.keys.each do |start_gengou|
        if start_gengou == gengou.to_s
          target_gengou = start_gengou
          break
        end
      end
      
      return nil unless target_gengou
      
      start_year = @@_gengou.invert[target_gengou].to_i
      return (start_year + year_jp.to_i - 1).to_s
    end
  
    def self.to_wareki(year, only_year: false)
      return nil unless year.present?

      target_year = nil
      @@_gengou.keys.sort.each do |start_year|
        break if start_year.to_i > year.to_i
        target_year = start_year
      end

      return nil unless target_year

      gengou  = @@_gengou[target_year]
      year_jp = year - target_year + 1

      if only_year
        year_jp.to_s
      else
        gengou + (year_jp == 1 ? '元' : year_jp.to_s)
      end
    end

  end
end
