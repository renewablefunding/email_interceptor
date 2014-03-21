# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_interceptor/version'

Gem::Specification.new do |spec|
  spec.name          = "email_interceptor"
  spec.version       = EmailInterceptor::VERSION
  spec.authors       = ["Renewable Funding"]
  spec.email         = ["dave.miller@renewfund.com", "maher@renewfund.com", "laurie@renewfund.com", "ravi@renewfund.com"]
  spec.description   = %q{A small utility for shunting email to a an email address, depending on settings}
  spec.summary       = %q{Using this, you can rewrite recipient lists to a test email account for all or only external users}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
