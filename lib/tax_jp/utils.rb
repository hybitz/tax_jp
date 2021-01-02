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
        YAML.load(File.read(File.join(data_dir, filename)))
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

      def with_database(db_path, results_as_hash: false)
        db = SQLite3::Database.new(db_path)
        db.results_as_hash = results_as_hash

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
          if value =~ /[0-9]{4}-[0-9]{2}-[0-9]{2}/
            ret = value
          else
            raise ArgumentError.new(value)
          end
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

      def filename_to_date(filename)
        _, valid_from, valid_until = File.basename(filename).split('.').first.split('-')
        valid_from = Date.strptime(valid_from, '%Y%m%d')
        valid_until = Date.strptime(valid_until, '%Y%m%d')
        [valid_from.strftime('%Y-%m-%d'), valid_until.strftime('%Y-%m-%d')]
      end

      def normalize_amount(amount, options = {})
        ret = amount.to_s

        if ret == '-'
          ret = TaxJp::INTEGER_MAX
        else
          ret = ret.gsub(',', '')
          if ret.index('.')
            ret = ret.to_f
          else
            ret = ret.to_i
          end
        end
      
        ret
      end

    end
  end
end
