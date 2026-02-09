## [Unreleased]

## [0.6] - 2026-02-09
### Added
- Added ability to filter model on `id` attribute
  - `.with_id?` -> An entity exists that with the id specified
  - `.with_id` -> Returns the entity with the id specified
- Added ability to delete models where caching is enabled
- When updating models, the cache is also updated to reflect the new values

### Changed
- The primary key (if defined), re-orders attributes and their inspected values to show the primary id attribute first

## [0.5] - 2025-12-30
### Added
- Added humanized form of `#inspect` and `#to_s` for better readability when outputting model instances
- Added internal logger
- Added `#update` method to all models to update attributes post-creation
- Created ability to filter model entities
  - Simple filters have been added that leans on a private `.find_by` -> returning entities that matches the criteria
    - `.exists?` -> An entity exists that matches the criteria
    - `.with_email` -> Returns the entity with the email address specified
- Added ability to provide the primary key for a model via `.primary_key` class method
  - This will be used in the future for deduplication logic

### Changed
- **Breaking change**: Renamed the cache to `:all` and the iVar` to `@all` for clarity

## [0.4.1] - 2025-12-22
### Fixed
- Removed the `type` config as this was broken, across both model and attribute
- Properly determine the presence helper value based on the outputted value not the type inferred

## [0.4] - 2025-12-16
### Added
- Added iVars into model instantiation for each attribute in creation hash
- Moved the majority of the model methods out to a new settings class to encapsulate settings of a model
- Added a `.current` cache to each model
- When calling `Model.create` the output is stored as the current entity for the model in question

### Changed
- **Breaking change**: Renamed the `property` and `properties` methods to `attribute` and `attributes` respectively
- Improved the first "any" helper (Now renamed to presence), to check for more nuanced items
  - For singular / default items, it checks the string is not empty
  - For plural items, it still checks if any are present

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

[Unreleased]:   https://github.com/site-prism/testingrecord/compare/v0.6...HEAD
[0.6]:          https://github.com/site-prism/testingrecord/compare/v0.5...v0.6
[0.5]:          https://github.com/site-prism/testingrecord/compare/v0.4.1...v0.5
[0.4.1]:        https://github.com/site-prism/testingrecord/compare/v0.4...v0.4.1
[0.4]:          https://github.com/site-prism/testingrecord/compare/v0.3...v0.4
[0.3]:          https://github.com/site-prism/testingrecord/compare/0.2...v0.3
[0.2]:          https://github.com/site-prism/testingrecord/compare/0.1...v0.2
[0.1]:          https://github.com/site-prism/testingrecord/commit/3777aec
