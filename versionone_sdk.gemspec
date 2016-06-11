require File.expand_path('../lib/versionone_sdk/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'versionone_sdk'
  s.version     = VersiononeSdk::VERSION
  s.author      = 'John Wang'
  s.email       = 'john@johnwang.com'
  s.homepage    = 'http://johnwang.com/'
  s.date        = '2016-06-10'
  s.summary     = 'VersionOne SDK - A Ruby SDK for the VersionOne REST API'
  s.license     = 'MIT'
  s.description = 'A Ruby SDK for the VersionOne REST API'
  s.licenses    = ['MIT']
  s.files       = Dir['lib/**/**/*'] + Dir['test/**/*'] \
                + Dir['[A-Z]*'].grep(/^[A-Z]/).select {|s|/Gemfile\.lock/ !~ s}
  s.add_dependency 'faraday', '~> 0', '>= 0'
  s.add_dependency 'jsondoc', '~> 0.1', '>= 0.1.2'
  s.add_dependency 'nokogiri', '~> 1.5', '>= 1.5.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'coveralls', '~> 0.8.13'
  s.require_path = 'lib'
end
