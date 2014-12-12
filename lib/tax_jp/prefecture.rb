require 'yaml'

module TaxJp
  class Prefecture
    attr_reader :code, :name

    def initialize(code, name)
      @code = code
      @name = name
    end

    @@prefectures = {}
    gem_dir = File.dirname(File.dirname(File.dirname(__FILE__)))
    prefectures = YAML.load_file(File.join(gem_dir, 'data', 'prefectures.yml'))['prefectures']
    prefectures.each do |key, value|
      code = "%02d" % key.to_i
      @@prefectures[code] = Prefecture.new(code, value)
    end

    def self.all
      @@prefectures.values
    end

    def self.find_by_code(code)
      @@prefectures[code.to_s]
    end

  end
end
