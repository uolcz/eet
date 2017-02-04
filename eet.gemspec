# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eet/version'

Gem::Specification.new do |spec|
  spec.name          = "eet"
  spec.version       = Eet::VERSION
  spec.authors       = ["Premysl Donat"]
  spec.email         = ["pdonat@seznam.cz"]

  spec.summary       = "Simple eet sender"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savon"
  spec.add_dependency "eet_signer", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
