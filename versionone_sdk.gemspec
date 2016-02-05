require File.expand_path('../lib/versionone_sdk/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'versionone_sdk'
  s.version     = VersiononeSdk::VERSION
  s.author      = 'John Wang'
  s.email       = 'john@johnwang.com'
  s.homepage    = 'http://johnwang.com/'
  s.date        = '2016-02-05'
  s.summary     = 'VersionOne SDK - A Ruby SDK for the VersionOne REST API'
  s.license     = 'MIT'
  s.description = 'A Ruby SDK for the VersionOne REST API'
  s.licenses    = ['MIT']
  s.files       = Dir['lib/**/**/*'] + Dir['test/**/*'] \
                + Dir['[A-Z]*'].grep(/^[A-Z]/).select {|s|/Gemfile\.lock/ !~ s}
  s.add_dependency 'faraday', '~> 0', '>= 0'
  s.add_dependency 'jsondoc', '~> 0', '>= 0.0.4'
  s.add_dependency 'nokogiri', '~> 1.5', '>= 1.5.0'
  s.require_path = 'lib'
end
