lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tax_jp/version'

Gem::Specification.new do |spec|
  spec.name          = "tax_jp"
  spec.version       = TaxJp::VERSION
  spec.authors       = ["ichy"]
  spec.email         = ["ichylinux@gmail.com"]
  spec.summary       = %q{消費税計算ライブラリ}
  spec.description   = %q{消費税計算ライブラリ}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
