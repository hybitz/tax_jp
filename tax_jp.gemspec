$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "tax_jp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tax_jp"
  s.version     = TaxJp::VERSION
  s.authors     = ['ichylinux', 'hyzhiro']
  s.email       = ['ichylinux@gmail.com', 'hiroyuki.suzuki@hybitz.co.jp']
  s.homepage    = "https://github.com/hybitz/tax_jp"
  s.summary     = %q{税金計算ライブラリ}
  s.description = %q{税金計算ライブラリ}
  s.license     = "MIT"

  s.files = Dir["{app,config,data,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = '~> 2.7'

  s.add_dependency 'bootstrap', '~> 5.0'
  s.add_dependency 'rails', '>= 5.2', '< 7.0'
  s.add_dependency 'sqlite3', '~> 1.3', '< 1.7'
end
