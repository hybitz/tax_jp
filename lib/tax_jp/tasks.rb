require 'tax_jp'

Dir[File.join(TaxJp::Utils.gem_dir, 'lib', 'tasks', '*.rake')].each do |f|
  load f
end
