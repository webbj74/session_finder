# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'session_finder/version'

Gem::Specification.new do |spec|
  spec.name          = "session_finder"
  spec.version       = SessionFinder::VERSION
  spec.authors       = ["Jonathan Webb"]
  spec.email         = ["jonathan.webb@acquia.com"]
  spec.description   = %q{Find sessions or other Varnsish disruptors}
  spec.summary       = %q{Find sessions or other Varnsish disruptors}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "faye/websocket"
  spec.add_development_dependency "em-http"
  spec.add_development_dependency "json"
end
