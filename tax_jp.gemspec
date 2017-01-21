lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tax_jp/version'

Gem::Specification.new do |s|
  s.name          = "tax_jp"
  s.version       = TaxJp::VERSION
  s.authors       = ['ichylinux', 'hyzhiro']
  s.email         = ['ichylinux@gmail.com', 'hiroyuki@hybitz.co.jp']
  s.summary       = %q{税金計算ライブラリ}
  s.description   = %q{税金計算ライブラリ}
  s.homepage      = 'https://github.com/hybitz/tax_jp'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.required_ruby_version = '~> 2.1'

  s.add_runtime_dependency 'sqlite3', '~> 1.3'

  s.add_development_dependency 'bundler', '~> 1.12'
  s.add_development_dependency 'closer', '~> 0.3'
  s.add_development_dependency 'rake', '~> 11.0'
  s.add_development_dependency 'rails', '>= 4.0', '< 5.0.0'
end
