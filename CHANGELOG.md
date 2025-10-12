## 0.0.1

* Initial release

## 0.1.0

* Add example
* Update OneUIView

## 0.2.0

* Add expandedHeight to OneUIView
* Change children to child in OneUIView

## 0.3.0

* Add some options to OneUIView
* Update widgets for One UI 4.0

## 0.3.1

* Fix dependencies problem

## 0.3.3

### Added
- Upgrade package to support for version 3.29.2

### Changed
- Update deprecated APIs and fix example project configurations 
- Update icon_button.dart

### Fixed
- Minor big fix related to the nullable properties
- Null-error fixed and code refactoring

## 0.3.4

* **Breaking Change**: Removed deprecated `title` property from `OneUIBottomNavigationBarItem`. Use `label` instead.
  - Migration: Replace `OneUIBottomNavigationBarItem(title: "Text")` with `OneUIBottomNavigationBarItem(label: "Text")`
* Updated `vector_math` dependency to ^2.2.0 for latest features and compatibility
* Ensured compatibility with Flutter 3.24.x and Dart SDK >=3.5.0
