# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape/builder/version'

Gem::Specification.new do |spec|
  spec.name          = "grape-builder"
  spec.version       = Grape::Builder::VERSION
  spec.authors       = ["Plex"]
  spec.email         = ["masushu@gmail.com"]
  spec.description   = %q{Use Builder in Grape}
  spec.summary       = %q{Use Builder in Grape}
  spec.homepage      = "https://github.com/plexinc/grape-builder"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "grape", ">= 0.3"
  spec.add_dependency "builder"
  spec.add_dependency "tilt"
  spec.add_dependency "i18n"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "equivalent-xml"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
