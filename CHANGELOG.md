CHANGELOG
---------

- **2014-03-24**: 0.1.0
  - Update JSON representation to use Array for multiple values and String for single values for both Attribute and Relation tags. Previously Relation tags would be converted to arrays even if there was only a single element. This change is not backward compatible.
- **2014-03-20**: 0.0.4
  - Fix for VersiononeSdk::Update::updateAsset
- **2014-03-20**: 0.0.3
  - Add ability to retrieve a single asset using an OID token or Number
  - Add VersiononeSdk::Update to support updating Assets
- **2014-03-17**: 0.0.2
  - Add VersiononeSdk::Asset object to support value inflation, starting with AssetState.Name
- **2014-03-16**: 0.0.1
  - Initial release