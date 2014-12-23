module TaxJp
  module Rails
    class Railtie < ::Rails::Railtie

      rake_tasks do
        require 'tax_jp/tasks'
      end

    end
  end
end
