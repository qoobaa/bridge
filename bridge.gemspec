# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "bridge/version"

Gem::Specification.new do |s|
  s.name        = "bridge"
  s.version     = Bridge::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Contract bridge utilities"
  s.description = "Useful contract bridge utilities - deal generator, id to deal and deal to id conversion"
  s.email       = "qoobaa+github@gmail.com"
  s.homepage    = "http://github.com/qoobaa/bridge"
  s.authors     = ["Jakub Kuźma", "Wojciech Wnętrzak"]

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bridge"

  s.add_development_dependency "bundler", ">= 1.0.0.rc.5"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = "lib"
end
