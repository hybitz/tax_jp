require 'erb'

module TaxJp
  class Utils
    class << self

      def gem_dir
        File.expand_path('../../..', __FILE__)
      end

      def data_dir
        File.join(gem_dir, 'data')
      end

      def load_yaml(filename)
        YAML.load_file(File.join(data_dir, filename))
      end

      def load_file(filename)
        File.read(File.join(data_dir, filename))
      end

      def render(filename)
        src = File.join(gem_dir, 'templates', filename + '.erb')
        dest = File.join(gem_dir, filename)
        FileUtils.mkdir_p(File.dirname(dest))
        File.write(dest, ERB.new(File.read(src), 0, '-').result)
      end

    end
  end
end
