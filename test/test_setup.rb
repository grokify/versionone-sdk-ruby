require 'test/unit'
require 'versionone_sdk'

require 'pp'

class VersiononeSdkTest < Test::Unit::TestCase
  def testSetup
    oAsset  = VersiononeSdk::Asset.new
    oClient = VersiononeSdk::Client.new
    oParser = VersiononeSdk::ParserXmlAssets.new

    assert_equal 'VersiononeSdk::Asset', oAsset.class.name
    assert_equal 'VersiononeSdk::Client', oClient.class.name
    assert_equal 'VersiononeSdk::ParserXmlAssets', oParser.class.name
  end

  def testAsset
    oAsset = VersiononeSdk::Asset.new({hello: 'world'},{},false,false)
    assert_equal 'world', oAsset.getAttr(:hello)

    oAsset.setProp(:AssetState, '128')
    oAsset.inflateNames()

    assert_equal 'Closed', oAsset.getProp(:'AssetState.Name')
  end

  def testClient
    oClient = VersiononeSdk::Client.new(instance: 'Test')
    assert_equal 'https://localhost:443/Test/rest-1.v1/Data/',
                    oClient.getUrlForAssets
    assert oClient.oFaraday.ssl.verify

    oClient = VersiononeSdk::Client.new(instance: 'Test', ssl_verify: false)
    assert !(oClient.oFaraday.ssl.verify)

    oClient = VersiononeSdk::Client.new(protocol: 'http', user: 'user',
                password: 'pass', port: 80, appauth: '', instance: 'Test')
    assert_equal 'http://localhost/Test/rest-1.v1/Data/', oClient.getUrlForAssets
    assert_match /\ABasic /, oClient.oFaraday.headers['Authorization']

    sAppAuth = 'some_string_generated_from_version_one'
    oClient = VersiononeSdk::Client.new(protocol: 'https', port: 443,
                appauth: sAppAuth, instance: Test)
    assert_equal "Bearer #{sAppAuth}", oClient.oFaraday.headers['Authorization']
  end
end
