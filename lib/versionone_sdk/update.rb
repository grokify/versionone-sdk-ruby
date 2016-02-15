require 'nokogiri'

module VersiononeSdk
  class Update
    def initialize(oClient=nil)
      @oClient = oClient
      @dTagTypes = {simple_attribute: 1, single_relationship: 1, multi_relationship: 1}
      @sRelationships = 'BuildProjects,Owner,Parent,Schedule,Scheme,SecurityScope,Status,TestSuite'
      @dRelationships = Hash[@sRelationships.split(',').collect {|v| [v,1]}]
    end

    # Update a VersionOne asset.
    #
    # Params:
    # +sAssetType+:: A REST API asset type such as Scope, Epic, Story, Member, etc. The first part of the OID Token.
    # +sAssetOid+:: The numerical OID and the second part of the OID token.
    # +sName+:: Name of attribute to be updated.
    # +xxValues+:: values to be updated which can be a variety of formats.
    # +yTagType+:: A optional symbol to identify the type of attribute, e.g.
    # :simple_attribute, :single_relationship, or :multi_relationship
    def updateAsset(sAssetType=nil,sAssetOid=nil,sName=nil,xxValues=nil,yTagType=nil)
      aValues  = normalizeValues(xxValues)
      # Validate Tag Type
      yTagType = yTagType.to_sym if yTagType.is_a?(String)

      unless yTagType.nil?
        unless @dTagTypes.key?(yTagType)
          raise ArgumentError, "E_BAD_TAG_TYPE: [#{yTagType.to_s}]"
        end
      else
        if sName.nil? || ! sName.kind_of?(String)
          raise ArgumentError, 'E_NO_ATTRIBUTE_NAME'
        elsif @dRelationships.key?(sName)
          aValues.each do |dValue|
            sAct = dValue[:act]
            if sAct    == 'set'
              yTagType =  :single_relationship
            elsif sAct == 'add' || sAct == 'remove'
              yTagType =  :multi_relationship
            else
              raise ArgumentError, "E_BAD_ACT: [#{sAct}]"
            end
          end
        else
          yTagType = :simple_attribute
        end
      end

      xBody \
        = yTagType == :simple_attribute    \
        ? getXmlBodyForSimpleAttributeUpdate(sName,aValues) \
        : yTagType == :single_relationship \
        ? getXmlBodyForSingleRelationship(sName,aValues)    \
        : yTagType == :multi_relationship  \
        ? getXmlBodyForMultiRelationship(sName,aValues)     \
        : nil

      unless xBody.nil?
        oFdRes = @oClient.oFaraday.post do |req|
          req.url getUrlForAssetTypeAndOid(sAssetType,sAssetOid)
          req.headers['Content-Type'] = 'application/xml'
          req.body = xBody
        end
        return oFdRes
      end

      return nil

    end

    private

    def normalizeValues(xxValues=nil)
      aValues = []

      if xxValues.is_a?(String)
        aValues = [{value: xxValues, act: 'set'}]
      elsif xxValues.is_a?(Hash)
        aValues = [xxValues]
      elsif xxValues.is_a?(Array)
        xxValues.each do |xxSubValue|
          if xxSubValue.is_a?(String)
            sAct = xxValues.length > 1 ? 'add' : 'set'
            aValues.push({value: xxSubValue, act: sAct})
          elsif xxSubValue.is_a?(Hash)
            aValues.push(xxSubValue)
          end
        end
      end

      return aValues
    end

    def getUrlForAssetTypeAndOid(sAssetType=nil,sAssetOid=nil)
      sUrl = File.join('/'+@oClient.sInstance,'rest-1.oauth.v1/Data',sAssetType,sAssetOid.to_s)
      return sUrl
    end

    def getXmlBodyForSimpleAttributeUpdate(sName=nil,aValues=[])
      sValue   = aValues.length>0 && aValues[0].key?(:value) \
        ? aValues[0][:value] : nil
      oBuilder = Nokogiri::XML::Builder.new do |xml|
        xml.Asset {
          xml.Attribute(sValue, name: sName, act: 'set')
        }
      end
      return oBuilder.to_xml
    end

    def getXmlBodyForSingleRelationship(sName=nil,aValues=[])
      sValue   = aValues.length>0 && aValues[0].key?(:value) \
        ? aValues[0][:value] : nil
      oBuilder = sValue.nil? \
        ? Nokogiri::XML::Builder.new { |xml| xml.Asset { \
            xml.Relation(name: sName, act: 'set')
        } }
        : Nokogiri::XML::Builder.new { |xml| xml.Asset { \
            xml.Relation(name: sName, act: 'set') {
              xml.Asset(idref: sValue)
            }
        } }
      return oBuilder.to_xml
    end

    def getXmlBodyForMultiRelationship(sName=nil,aValues=[])
      oBuilder = aValues.length == 0 \
        ? Nokogiri::XML::Builder.new { |xml| xml.Asset { \
            xml.Relation(name: sName, act: 'set')
        } }
        : Nokogiri::XML::Builder.new { |xml| xml.Asset { \
            xml.Relation(name: sName) {
              aValues.each do |dValue|
                xml.Asset(idref: dValue[:value], act: dValue[:act])
              end
            }
        } }
      return oBuilder.to_xml
    end
  end
end
