# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_v3_api/version'

Gem::Specification.new do |spec|
  spec.name          = "github-v3-api"
  spec.version       = GitHubV3API::VERSION
  spec.authors       = ["John Wilger"]
  spec.email         = ["johnwilger@gmail.com"]
  spec.description   = %q{Ponies}
  spec.summary       = %q{Ruby Client for the GitHub v3 API}
  spec.homepage      = "http://github.com/jwilger/github-v3-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency(%q<rest-client>, [">= 0"])
  spec.add_runtime_dependency(%q<json>, [">= 0"])
  spec.add_development_dependency(%q<rspec>, [">= 0"])
  spec.add_development_dependency(%q<sinatra>, [">= 0"])
  spec.add_development_dependency(%q<omniauth>, [">= 0"])
end
