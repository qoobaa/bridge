# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bridge/version"

Gem::Specification.new do |spec|
  spec.name        = "bridge"
  spec.version     = Bridge::VERSION
  spec.summary     = "Contract bridge utilities"
  spec.description = "Useful contract bridge utilities - deal generator, id to deal and deal to id conversion"
  spec.email       = "qoobaa+github@gmail.com"
  spec.homepage    = "https://github.com/qoobaa/bridge"
  spec.authors     = ["Jakub Kuźma", "Wojciech Wnętrzak"]
  spec.license     = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 1.9.3"

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake"
end
