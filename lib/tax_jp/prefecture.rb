require 'yaml'

module TaxJp
  module Prefecture
    @@prefectures = {}

    def find_prefecture_by_code(code)
      unless @@prefectures['prefectures']
        gem_dir = File.dirname(File.dirname(File.dirname(__FILE__)))
        prefectures = YAML.load_file(File.join(gem_dir, 'data', 'prefectures.yml'))['prefectures']
        prefectures.each do |key, value|
          @@prefectures["%02d" % key.to_i] = value
        end
      end

      @@prefectures[code.to_s]
    end

  end
end
