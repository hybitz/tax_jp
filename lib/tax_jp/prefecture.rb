require 'yaml'

module TaxJp
  class Prefecture
    attr_reader :code, :name

    def initialize(code, name)
      @code = code
      @name = name
    end

    @@prefectures_by_code = {}
    @@prefectures_by_name = {}
    TaxJp::Utils.load_yaml('都道府県.yml').each do |key, value|
      code = "%02d" % key.to_i
      p = Prefecture.new(code, value)
      @@prefectures_by_code[p.code] = @@prefectures_by_name[p.name] = p
    end

    def self.all
      @@prefectures_by_code.values
    end

    def self.find_by_code(code)
      @@prefectures_by_code["%02d" % code.to_i]
    end

    def self.find_by_name(name)
      @@prefectures_by_name[name]
    end

  end
end
