require 'yaml'

module TaxJp
  class Gengou
    @@_gengou = TaxJp::Utils.load_yaml('元号.yml')
  
    def self.to_seireki(gengou, date_jp)
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
  
    def self.to_wareki(date, only_date: false, format: '%y年%m月%d日')
      return nil unless date.present?

      date = TaxJp::Utils.convert_to_date(date)

      target_date = nil
      @@_gengou.keys.each do |start_date|
        target_date = TaxJp::Utils.convert_to_date(start_date)
        break if date >= target_date
      end

      return nil unless target_date

      target_date = Date.strptime(target_date)
      year, month, day = *(date.split('-').map{|x| x.to_i})
      year_jp = year - target_date.year + 1

      ret = Date.new(year_jp, month, day)
      if only_date
        ret = ret.strftime(format)
      else
        gengou  = @@_gengou[target_date]
        year_jp = year_jp == 1 ? '元' : year_jp.to_s
        ret = ret.strftime(format.gsub('%y', "#{gengou}#{year_jp}"))
      end

      ret
    end

  end
end
