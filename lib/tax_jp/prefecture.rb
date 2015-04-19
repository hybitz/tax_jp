require 'yaml'

module TaxJp
  class Prefecture
    attr_reader :code, :name

    def initialize(code, name)
      @code = code
      @name = name
    end

    @@prefectures = {}
    TaxJp::Utils.load_yaml('都道府県.yml').each do |key, value|
      code = "%02d" % key.to_i
      @@prefectures[code] = Prefecture.new(code, value)
    end

    def self.all
      @@prefectures.values
    end

    def self.find_by_code(code)
      @@prefectures["%02d" % code.to_i]
    end

  end
end
