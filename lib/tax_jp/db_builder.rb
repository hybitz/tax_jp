module TaxJp
  class DbBuilder

    attr_reader :db_path

    def initialize(db_path)
      @db_path = db_path
    end

    protected

    def with_database(options = {})
      recreate = options.fetch(:recreate, true)

      FileUtils.rm_f(db_path) if recreate
      db = SQLite3::Database.new(db_path)
      recreate_schema(db) if recreate

      begin
        yield db
      ensure
        db.close
      end
    end

    def recreate_schema(db)
      raise 'サブクラスでオーバライド'
    end
  end
end