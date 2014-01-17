require File.expand_path('../lib/iron_consumer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Travis Reeder"]
  gem.email         = ["travis@iron.io"]
  gem.description   = "Ruby client for IronWorker by www.iron.io"
  gem.summary       = "Ruby client for IronWorker by www.iron.io"
  gem.homepage      = "https://github.com/iron-io/iron_consumer"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "iron_consumer"
  gem.require_paths = ["lib"]
  gem.version       = IronConsumer::VERSION

  gem.required_rubygems_version = ">= 1.3.6"
  gem.required_ruby_version = Gem::Requirement.new(">= 1.9")
  gem.add_runtime_dependency "iron_mq", ">= 4.0.0"
  gem.add_runtime_dependency "iron_worker_ng"

  gem.add_development_dependency "test-unit"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "rake"

end

