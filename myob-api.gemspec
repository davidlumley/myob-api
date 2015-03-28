# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'myob/api/version'

Gem::Specification.new do |spec|
  spec.name          = "myob-api"
  spec.version       = Myob::Api::VERSION
  spec.authors       = ["David Lumley"]
  spec.email         = ["david@davidlumley.com.au"]
  spec.description   = %q{MYOB AccountRight Live API V2}
  spec.summary       = %q{MYOB AccountRight Live API V2}
  spec.homepage      = "https://github.com/davidlumley/myob-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "oauth2", "> 0.8"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "timecop"
end
