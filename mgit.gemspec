$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'mgit/version'

Gem::Specification.new do |s|
  s.name          = 'mgit'
  s.version       = MGit::VERSION
  s.license       = 'MIT'
  s.summary       = 'MGit meta repository tool'
  s.description   = 'M[eta]Git let\'s you manage multiple git repositories simultaneously'

  s.authors       = ['FlavourSys Technology GmbH']
  s.email         = 'technology@flavoursys.com'
  s.homepage      = 'http://github.com/flavoursys/mgit'

  s.require_paths = ['lib']
  s.files         = Dir.glob('lib/**/*.rb')
  s.executables   = ['mgit']

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'colorize', '~> 0.7'
  s.add_dependency 'highline', '~> 1.6'
  s.add_dependency 'xdg', '~> 2.2'

  s.add_development_dependency 'rspec', '~> 2.14'
end
