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

      def with_database(db_path)
        db = SQLite3::Database.new(db_path)
        begin
          yield db
        ensure
          db.close
        end
      end

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

      def convert_to_zip_code(value)
        ret = nil
    
        if value.is_a?(String)
          ret = value.sub('-', '')
        else
          raise TypeError.new(value.class)
        end

        ret
      end

    end
  end
end
