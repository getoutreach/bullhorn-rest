# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bullhorn/rest/version'

Gem::Specification.new do |spec|
  spec.name          = "bullhorn-rest"
  spec.version       = Bullhorn::Rest::VERSION
  spec.authors       = ["Gordon L. Hempton"]
  spec.email         = ["ghempton@gmail.com"]
  spec.summary       = %q{Ruby wrapper for the Bullhorn REST API}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/GroupTalent/bullhorn-rest"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "active_support"
  spec.add_dependency "i18n"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
