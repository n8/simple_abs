# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_abs/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_abs"
  spec.version       = SimpleAbs::VERSION
  spec.authors       = ["nate"]
  spec.email         = ["nate@cityposh.com"]
  spec.description   = %q{Really simple way to do AB tests in Rails}
  spec.summary       = %q{Really simple way to do AB tests in Rails}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
