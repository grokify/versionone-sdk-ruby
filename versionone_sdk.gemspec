require File.expand_path('../lib/versionone_sdk/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'versionone_sdk'
  s.version     = VersiononeSdk::VERSION
  s.author      = 'John Wang'
  s.email       = 'john@johnwang.com'
  s.homepage    = 'http://johnwang.com/'
  s.date        = '2014-03-24'
  s.summary     = 'VersionOne SDK - A Ruby SDK for the VersionOne REST API'
  s.license     = 'MIT'
  s.description = 'A Ruby SDK for the VersionOne REST API'
  s.files       = [
    'CHANGELOG.md',
    'LICENSE.txt',
    'README.md',
    'Rakefile',
    'VERSION',
    'lib/versionone_sdk.rb',
    'lib/versionone_sdk/asset.rb',
    'lib/versionone_sdk/client.rb',
    'lib/versionone_sdk/parser_xml_assets.rb',
    'lib/versionone_sdk/update.rb',
    'lib/versionone_sdk/version.rb',
    'test/test_setup.rb'
  ]
  s.add_dependency 'faraday', '~> 0', '>= 0'
  s.add_dependency 'jsondoc', '~> 0', '>= 0.0.4'
  s.add_dependency 'nokogiri', '~> 1.5', '>= 1.5.0'
  s.require_path = 'lib'
end