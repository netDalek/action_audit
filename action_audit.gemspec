# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_audit/version'

Gem::Specification.new do |spec|
  spec.name          = "action_audit"
  spec.version       = ActionAudit::VERSION
  spec.authors       = ["denis.kirichenko"]
  spec.email         = ["denis.kirichenko@gmail.com"]
  spec.description   = %q{Allows to record models changes}
  spec.summary       = %q{Allows to record models changes. It can be ActiveRecord models or any other. Observer for ActiveRecord are included, for other models you should write your own code. You should also take care where to store this changes.}
  spec.homepage      = "https://github.com/netDalek/action_audit"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'micromachine', '~> 1.1'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
