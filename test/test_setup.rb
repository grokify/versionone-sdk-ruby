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
end
