# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/owly/version'

Gem::Specification.new do |spec|
  spec.name          = "owly"
  spec.version       = Owly::VERSION
  spec.authors       = ["Evan Reeves"]
  spec.email         = ["web@evanreeves.com"]
  spec.description   = %q{Ruby library for the ow.ly REST API}
  spec.homepage      = "https://www.github.com/jadedevan/owly"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "simple_oauth"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_development_dependency "rspec", "~>3.4"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
end
