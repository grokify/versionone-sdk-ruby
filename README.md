VersionOne SDK - A Ruby SDK for the VersionOne REST API
=======================================================

[![Gem Version][gem-version-svg]][gem-version-link]
[![Build Status][build-status-svg]][build-status-link]
[![Dependency Status][dependency-status-svg]][dependency-status-link]
[![Code Climate][codeclimate-status-svg]][codeclimate-status-link]
[![Scrutinizer Code Quality][scrutinizer-status-svg]][scrutinizer-status-link]
[![Downloads][downloads-svg]][downloads-link]
[![Docs][docs-rubydoc-svg]][docs-rubydoc-link]
[![License][license-svg]][license-link]

## Synopsis

This is a VersionOne SDK in Ruby that accesses the VersionOne REST API.

VersionOne currently offers SDKs in Java, .NET, Python and JavaScript but not in Ruby or other languages. This SDK seeks to provide an easier way to use the REST API for Ruby applications.

It currently offers the following capabilities:

1. Ability to retrieve and parse all Assets of a certain type to JSON (via JsonDoc)
2. Ability to query Assets transparently using Asset OID Tokens (e.g. `Story:1`) or Asset Numbers (e.g. `B-1`).
3. Ability to update Assets using Ruby without needing to manually create XML.

## Installation

### Via Bundler

Add 'versionone_sdk' to `Gemfile` and then run `bundle`:

```sh
$ echo "gem 'versionone_sdk'" >> Gemfile
$ bundle
```

### Via RubyGems

```sh
$ gem install versionone_sdk
```

This gem uses `nokogiri` which requires Ruby >= 1.9.2.

## Examples

```ruby
require 'versionone_sdk'

params = {
  hostname: 'www1.v1host.com',
  instance: 'myinstance',
  username: 'myusername',
  password: 'mypassword',
  port: 443,
  protocol: 'https'
}

v1client = VersiononeSdk::Client.new(params)
    
# Retrieve an array of VersiononeSdk::Asset objects

assets   = v1client.getAssets('Scope')

assets.each do |asset|
  assetHash = asset.asHash
end

# Retrieve a single asset using an Asset OID Token
# Returns a VersiononeSdk::Asset object
asset = v1client.getAsset("Story:1")
asset = v1client.getAsset("Story",1)

# Retrieve a single asset using an Asset Number
asset = v1client.getAsset("B-1")
asset = v1client.getAsset("B",1)

# Updating an asset with a simple attribute
# Returns a Faraday::Response object
v1client.updateAsset("Member",20,"Phone","555-555-1212")
v1client.updateAsset("Member",20,"Phone",{:value=>"555-555-1212",:act=>"set"})
v1client.updateAsset("Member",20,"Phone",{:value=>"555-555-1212",:act=>"set"},\
  :simple_attribute
)

# Updating an asset with a single-value relationship:
v1client.updateAsset("Scope",0,"Owner","Member:20")
v1client.updateAsset("Scope",0,"Owner",{:value=>"Member:20",:act=>"set"})
v1client.updateAsset("Scope",0,"Owner",{:value=>"Member:20",:act=>"set"},:single_relationship)

# Updating an asset with a multi-value relationship: adding members
v1client.updateAsset("Scope",0,"Members",["Member:1000","Member:1001"],:multi_relationship)

# Updating an asset with a multi-value relationship: adding and removing members
v1client.updateAsset("Scope",0,"Members",[       \
  { :value => "Member:1000", :act => "add" },    \
  { :value => "Member:1001", :act => "remove " } \
],:multi_relationship)
```

## Documentation

This gem is 100% documented with YARD, an exceptional documentation library. To see documentation for this, and all the gems installed on your system use:

```bash
$ gem install yard
$ yard server -g
```

## Notes

1. Integer Values
 - Integer values for Order and AssetState are converted from strings to integers.
2. Nil/Null Values and Empty Strings
 - The VersionOne JavaScript API provides empty strings when no value is present. This SDK uses Ruby nil values and JSON null values for empty strings. The primary reason for this is to support easy indexing using Elasticsearch.
3. Inflation
 - Some values are inflated. Currently, AssetState is used to derive AssetState.Name as defined here: https://community.versionone.com/Developers/Developer-Library/Concepts/Asset_State
4. Tracking Properties
 - In addition to the standard VersionOne properties, this modules adds the following generic properties for tracking: `:__id__sObjectDomain`, `:__id__sObjectType`, `:__id__iObjectId`, `:__id__sObjectUrl`. The object domain is set to 'Versionone', while object type and object id correspond to VersionOne Asset types and ids. The URL is the full URL for the resource including protocol, host and port.

## Change Log

See [CHANGELOG.md](CHANGELOG.md).

## Links

Project Repo

* https://github.com/grokify/versionone-sdk-ruby

VersionOne API Documentation

* http://community.versionone.com/Developers/Developer-Library/Documentation/API

VersionOne API Documentation for Updating an Asset

* https://community.versionone.com/Developers/Developer-Library/Recipes/Update_an_Asset

## Copyright and License

VersiononeSdk &copy; 2014-2016 by [John Wang](mailto:johncwang@gmail.com).

VersiononeSdk is licensed under the MIT license. Please see the [LICENSE.txt](LICENSE.txt) document for more information.

## Warranty

This software is provided "as is" and without any express or implied warranties, including, without limitation, the implied warranties of merchantibility and fitness for a particular purpose.

 [gem-version-svg]: https://badge.fury.io/rb/versionone_sdk.svg
 [gem-version-link]: http://badge.fury.io/rb/versionone_sdk
 [build-status-svg]: https://api.travis-ci.org/grokify/versionone-sdk-ruby.svg?branch=master
 [build-status-link]: https://travis-ci.org/grokify/versionone-sdk-ruby
 [dependency-status-svg]: https://gemnasium.com/grokify/versionone-sdk-ruby.svg
 [dependency-status-link]: https://gemnasium.com/grokify/versionone-sdk-ruby
 [codeclimate-status-svg]: https://codeclimate.com/github/grokify/versionone-sdk-ruby/badges/gpa.svg
 [codeclimate-status-link]: https://codeclimate.com/github/grokify/versionone-sdk-ruby
 [scrutinizer-status-svg]: https://scrutinizer-ci.com/g/grokify/versionone-sdk-ruby/badges/quality-score.png?b=master
 [scrutinizer-status-link]: https://scrutinizer-ci.com/g/grokify/versionone-sdk-ruby/?branch=master
 [downloads-svg]: http://ruby-gem-downloads-badge.herokuapp.com/versionone_sdk
 [downloads-link]: https://rubygems.org/gems/versionone_sdk
 [docs-rubydoc-svg]: https://img.shields.io/badge/docs-rubydoc-blue.svg
 [docs-rubydoc-link]: http://www.rubydoc.info/gems/versionone_sdk/
 [license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
 [license-link]: https://github.com/grokify/versionone-sdk-ruby/blob/master/LICENSE.txt
