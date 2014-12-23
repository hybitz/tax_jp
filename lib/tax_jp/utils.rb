module TaxJp
  class Utils
    class << self

      def gem_dir
        File.expand_path('../../..', __FILE__)
      end

      def load_yaml(filename)
        YAML.load_file(File.join(gem_dir, 'data', filename))
      end

    end
  end
end
