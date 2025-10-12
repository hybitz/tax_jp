require_relative "lib/tax_jp/version"

Gem::Specification.new do |spec|
  spec.name        = "tax_jp"
  spec.version     = TaxJp::VERSION
  spec.authors     = ['ichylinux', 'hyzhiro']
  spec.email       = ['ichylinux@gmail.com', 'hiroyuki.suzuki@hybitz.co.jp']
  spec.homepage    = "https://github.com/hybitz/tax_jp"
  spec.summary     = %q{税金計算ライブラリ}
  spec.description = %q{税金計算ライブラリ}
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/hybitz/tax_jp/blob/master/HISTORY.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,data,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = '>= 3.2', '< 3.5'

  spec.add_dependency 'bootstrap', '~> 5.3'
  spec.add_dependency 'concurrent-ruby', '< 1.3.5'
  spec.add_dependency 'rails', '>= 6.1', '< 8.0'
  spec.add_dependency 'sqlite3', '>= 1.6', '< 2.0'
end
