# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_auditor/version'

Gem::Specification.new do |spec|
  spec.name          = "action_auditor"
  spec.version       = ActionAuditor::VERSION
  spec.authors       = ["denis.kirichenko"]
  spec.email         = ["denis.kirichenko@gmail.ru"]
  spec.description   = %q{Audit any change (ActiveRecord CRUD expecially) and group them by controller or any other action}
  spec.summary       = %q{Audit any change (ActiveRecord CRUD expecially) and group them by controller or any other action}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "micromachine"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
