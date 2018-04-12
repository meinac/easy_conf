# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_conf/version'

Gem::Specification.new do |spec|
  spec.name          = "easy_conf"
  spec.version       = EasyConf::VERSION
  spec.authors       = ["Mehmet Emin İNAÇ"]
  spec.email         = ["mehmetemininac@gmail.com"]

  spec.summary       = "Easily manage your app configurations."
  spec.description   = "EasyConf is a gem for reading configurations either from yaml files or from environment variables. With this gem you don't worry about where were your configurations."
  spec.homepage      = "http://github.com/meinac/easy_conf"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "vault"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
