module TaxJp
  class DbBuilder

    attr_reader :db_path

    def initialize(db_path)
      @db_path = db_path
    end

    protected

    def with_database(options = {})
      if options.fetch(:recreate, true)
        db = recreate_schema
      else
        db = SQLite3::Database.new(db_path)
      end

      begin
        yield db
      ensure
        db.close
      end
    end

    def recreate_schema
      raise 'サブクラスでオーバライド'
    end
  end
end