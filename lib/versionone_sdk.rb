module VersiononeSdk
  VERSION = '0.2.3'.freeze
  autoload :Asset,  'versionone_sdk/asset'
  autoload :Client, 'versionone_sdk/client'
  autoload :ParserXmlAssets, 'versionone_sdk/parser_xml_assets'
  autoload :Update, 'versionone_sdk/update'
end
