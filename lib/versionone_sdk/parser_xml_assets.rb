require 'jsondoc'
require 'nokogiri'
require 'versionone_sdk/asset'

module VersiononeSdk
  class ParserXmlAssets
    def initialize(dOptions={})
      @sUrl = dOptions.key?(:url) ? dOptions[:url] : ''
    end
    def getDocsForAssetsXmlPath(sPath=nil)
      if File.exists?(sPath)
        return self.getDocsForAssetsXml(IO.read(sPath))
      end
      return []
    end
    def getDocsForAssetsXml(xAssets=nil)
      oXml = Nokogiri::XML::Document.parse(xAssets)
      oBlock = oXml.xpath("//Assets/Asset")
      aDocs = []
      oBlock.map do |oNodeAsset|
        oAsset = self.getJsondocForXmlAssetNode( oNodeAsset )
        unless oAsset.nil?
          aDocs.push(oAsset)
        end
      end
      return aDocs
    end
    def getDocForAssetXml(xAsset=nil)
      oXml = Nokogiri::XML::Document.parse(xAsset)
      oAsset = self.getJsondocForXmlAssetNode( oXml.root )
      return oAsset
    end
    def getJsondocForXmlAssetNode(oNodeAsset=nil)
      if oNodeAsset.nil?
        raise RuntimeError, 'E_NIL_NODE'
      end
      oAsset = VersiononeSdk::Asset.new
      oAsset.bIsStrict = false
      sOidtokSrc       = nil
      sObjectType      = nil
      iObjectId        = nil
      if oNodeAsset.attribute('id')
        sOidtokSrc     =  oNodeAsset.attribute('id').value
        if sOidtokSrc  =~ /^(.+):([0-9]+)$/
          sObjectType  =  $1
          iObjectId    =  $2.to_i
          oAsset.setProp(:_sObjectDomain__id,'Versionone')
          oAsset.setProp(:_sObjectType__id,sObjectType)
          oAsset.setProp(:_iObjectId__id,  iObjectId)
        end
      end
      if oNodeAsset.attribute('href').value
        sUrl = @sUrl \
          ? @sUrl + oNodeAsset.attribute('href').value
          : oNodeAsset.attribute('href').value
        oAsset.setProp(:_sObjectUrl__id,sUrl)
      end
      oNodeAsset.children.each do |oNodeChild|
        if oNodeChild.name == 'Attribute' || oNodeChild.name == 'Relation'
          if oNodeChild.attribute('name')
            yPropKey = oNodeChild.attribute('name').to_s.to_sym
            xxPropVal = getAssetNodeChildPropVal( oNodeChild )
            oAsset.setProp(yPropKey,xxPropVal)
          end
        elsif oNodeChild.name == 'Message' && oNodeChild.text == 'Not Found'
          raise RuntimeError, "E_ASSET_NOT_FOUND #{oNodeAsset.attribute('href').value}"
        else
          raise RuntimeError, "E_UNKNOWN_ASSET_NODE_NAME #{oNodeChild.name}"
        end
      end
      oAsset.inflate
      return oAsset
    end

    def getAssetNodeChildPropVal(oNodeChild=nil)
      xxPropVal = nil
      aPropVals = []
      if oNodeChild.children.length > 0
        oNodeChild.children.each do |oNodeChildGrand|
          dAttributes = oNodeChildGrand.attributes
          xxPropVal   = dAttributes.key?('idref')    \
            ? oNodeChildGrand.attribute('idref').value \
            : oNodeChildGrand.text
          xxPropVal = nil if xxPropVal == ''
          aPropVals.push(xxPropVal)
        end
        if aPropVals.length > 1
          xxPropVal = aPropVals
        elsif aPropVals.length == 1
          xxPropVal == aPropVals[0]
        else
          xxPropVal = nil
        end
      else
        xxPropVal = oNodeChild.text
      end
      xxPropVal = nil if xxPropVal == ''
      return xxPropVal
    end
  end
end
