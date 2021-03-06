# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reference_book/version'

Gem::Specification.new do |spec|
  spec.name          = "reference_book"
  spec.version       = ReferenceBook::VERSION
  spec.author        = "Tommaso Pavese"
  spec.summary       = "A multi-context configuration library and DSL."
  spec.description   = "A multi-context configuration library and DSL. ReferenceBook provides an easy interface to define, validate and query multi-context configuration data."
  spec.homepage      = "https://github.com/tompave/reference_book"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.0.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 10.0'

  spec.add_development_dependency 'minitest', '~> 5.3'
end
