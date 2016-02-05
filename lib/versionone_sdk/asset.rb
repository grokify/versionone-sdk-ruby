require 'jsondoc'

module VersiononeSdk
  # VersiononeSdk::Asset class is a JsonDoc::Document subclass that includes
  # the #inflateNames method to add AssetState.Name based on the VersionOne
  # classifications avaiable at: https://community.versionone.com/Developers/Developer-Library/Concepts/Asset_State
  class Asset < JsonDoc::Document
    attr_accessor :dSchema

    def initialize(dValues=nil,dSchema=nil,bDefaultifyDoc=false,bIsStrict=true,opts={})
      opts[:bUseDeepKeys] = false
      super(dValues, dSchema, bDefaultifyDoc, bIsStrict, opts)
    end

    def getDefaultSchema()
      dSchema =  {}
      return dSchema
    end

    def inflate()
      self.inflateNames
      self.convertIntegers
    end

    def convertIntegers()
      [:Order,:AssetState].each do |yKey|
        xxVal = self.getProp(yKey)
        if xxVal.is_a?(String) && xxVal =~ /^-?[0-9]+$/
          xxVal = xxVal.to_i
          self.setProp(yKey,xxVal)
        end
      end
    end

    def inflateNames()
      dAssetState = {
        0   => 'Future',
        64  => 'Active',
        128 => 'Closed',
        200 => 'Template (Dead)',
        208 => 'Broken Down (Dead)',
        255 => 'Deleted (Dead)'
      }
      if @dDocument.key?(:AssetState)
        sAssetState = @dDocument[:AssetState]
        if sAssetState.is_a?(String) && sAssetState =~ /^[0-9]+$/
          iAssetState = sAssetState.to_i
          if dAssetState.key?(iAssetState)
            sAssetStateName = dAssetState[iAssetState]
            self.setProp(:'AssetState.Name',sAssetStateName)
          end
        end
      end
    end
  end
end
