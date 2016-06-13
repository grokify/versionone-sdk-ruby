require './test/test_base.rb'

class ParserXmlAssetsTest < Test::Unit::TestCase
  def testGetJsondocForXmlAssetNodeNilNodeFailure
    oParser = VersiononeSdk::ParserXmlAssets.new

    assert_raise (RuntimeError.new("E_NIL_NODE")) do
      oParser.getJsondocForXmlAssetNode(nil)
    end
  end

  def testGetJsondocForXmlAssetNodeAssetNotFound
    oParser = VersiononeSdk::ParserXmlAssets.new
 
    assert_raise(RuntimeError.new("E_ASSET_NOT_FOUND /v1sdktesting/rest-1.v1/Data/Story/12345")) do
      errorDocument = Nokogiri::XML('<Error href="/v1sdktesting/rest-1.v1/Data/Story/12345"><Message>Not Found</Message></Error>')
      oParser.getJsondocForXmlAssetNode(errorDocument.child)
    end
  end
end
