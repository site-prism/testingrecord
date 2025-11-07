## [Unreleased]
### Added
- Added iVars into model instantiation for each attribute in creation hash
- Moved the majority of the model methods out to a new settings class to encapsulate settings of a model

## [0.3] - 2025-09-09
### Added
- `.caching` option for generating the iVar and reader on the class
- Validators `#type_valid?` and `#caching_valid?` are enabled for checking the inputs on the model
- Properties can now be stored on the Model (All properties can be queried also)
- First helper added to builder logic - the `#any?` helper that will detect if anything is present
- Added the `.add_any_helper` class method for creating this helper method to a model
- Added the `.add_helpers` class method that will add all helpers to all properties on a model

## [0.2] - 2023-12-20
### Changed
- Attempt to clean up all code

## [0.1] - 2023-12-19
### Added
- Initial gem creation

[Unreleased]: https://github.com/site-prism/testingrecord/compare/v0.3...HEAD
[0.3]:        https://github.com/site-prism/testingrecord/compare/0.2...v0.3
[0.2]:        https://github.com/site-prism/testingrecord/compare/0.1...v0.2
[0.1]:        https://github.com/site-prism/testingrecord/commit/3777aec
