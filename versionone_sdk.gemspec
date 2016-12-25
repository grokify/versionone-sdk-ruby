lib = 'versionone_sdk'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = $1

Gem::Specification.new do |s|
  s.name        = lib
  s.version     = version
  s.author      = 'John Wang'
  s.email       = 'john@johnwang.com'
  s.homepage    = 'http://johnwang.com/'
  s.date        = '2016-06-17'
  s.summary     = 'VersionOne SDK - A Ruby SDK for the VersionOne REST API'
  s.license     = 'MIT'
  s.description = 'A Ruby SDK for the VersionOne REST API'
  s.licenses    = ['MIT']
  s.files       = Dir['lib/**/**/*'] + Dir['test/**/*'] \
                + Dir['[A-Z]*'].grep(/^[A-Z]/).select {|s|/Gemfile\.lock/ !~ s}

  s.add_dependency 'faraday', '~> 0', '>= 0'
  s.add_dependency 'jsondoc', '~> 0.1', '>= 0.1.2'
  s.add_dependency 'nokogiri', '~> 1.5', '>= 1.5.0'

  s.add_development_dependency 'rake', '~> 12'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'test-unit', '~> 3'
  s.add_development_dependency 'coveralls', '~> 0.8.13'
  s.require_path = 'lib'
end
