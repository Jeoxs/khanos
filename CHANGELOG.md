# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][Keep a Changelog] and this project adheres to [Semantic Versioning][Semantic Versioning].

## [Released]

## [1.1.1] - 2021-07-21
### Added
- Added Avatars to Tasks, subtasks, comments and Kanban

## [1.1.0] - 2021-07-19
### Added
- Changelog Section in Side Menu showing this Changelog
- Added Tutorial Dialog image for Cards

### Changed 
- Shimmer Animation colors for loading Activities

### Fixed
- Empty Overdue Tasks now shows the Empty Icon Image
- Common Framework Bugs and warnings

## [1.0.9] - 2021-07-18
### Added
- Comments section for tasks. User can add comments and remove them
- Added Overdue Tasks page in Home
- Added Activity Page in Home

### Fixed
- Kanban Columns duplicated when moving Items

## [1.0.8] - 2021-07-16
### Added
- Subtasks can be Reordered by long pressing and Drag.

## [1.0.7] - 2021-07-15
### Added
- Close Task Functionality
- Sound Feedback when tapping Cards
- Time Spent for Subtasks

### Fixed
- Cards Can be re-arranged inside column on Kanban
- Bottom padding on Tasks/Subtasks lists.
- Lowered Circle decoration in AppBar to fix overlaping in dark Mode
- Fixed Project Page task List not refreshing when updating the task


## [1.0.6] - 2021-07-13
### Added
- Kanban Functionality. Now you can drag tasks in Kanban View among columns.
- Added About Page
- Added developer's support link.

### Changed
- Wrapped Tasks/subtasks card's titles text to show full title of task, instead of excerpt

### Fixed
- Going back to login when logging in.


## [1.0.5] - 2021-07-11
### Added
- Dark Mode

## [1.0.4] - 2021-07-10
### Added
- Drawer Menu on Home Page with items
    - Support Link to This Github Repo
    - Logout option
- Projects can now be deleted with Slidable feature.
- Changed package Name as standars suggests. Note: You may want to uninstall the old app, as this one will use a new Package name.

## [1.0.3] - 2021-07-10
### Added
- Redirect to Login Screen if login credentials fails, notifying the user with a notification Bar at the bottom.
- Added Spent Time Field for Tasks
- Added "In Progress" Status for Subtasks. Now Subtasks have all the 3 status (undone, progress, completed).
- Added TimeTracking start/end for subtasks when started/completed

### Changed
- Changed task Page loading animation design.

### Fixed 
- Fixed Validation of response data from Server and added handling
- Fixed Color Picker from Task Form
- Fixed DateTime Fields in Task Form, adding a Limit date/time depending on Start/Due date selection
- Home Screen shows projects by User

## [1.0.2] - 2021-07-09
### Added
- Added Validation to API errors 403 Forbidden in Project Page

### Fixed
- Fixed Ending loading Project Page, because of 403 errors from API

## [1.0.1] - 2021-07-09
### Fixed
- Fixed Signatures for App in AndroidManifest & build.gradle.
- Fixed Title name in Main.dart (This title affects the running application in Android Devices)

## [1.0] - 2021-07-09
### Added
- Initial Release.


<!-- ## [Unreleased]

--- -->

---

<!-- Links -->
[Keep a Changelog]: https://keepachangelog.com/
[Semantic Versioning]: https://semver.org/

<!-- Versions -->
[Released]: https://github.com/Jeoxs/khanos/releases

[1.1.0]: https://github.com/Jeoxs/khanos/compare/v1.0.9...v1.1.0
[1.0.9]: https://github.com/Jeoxs/khanos/compare/v1.0.8...v1.0.9
[1.0.8]: https://github.com/Jeoxs/khanos/compare/v1.0.7...v1.0.8
[1.0.7]: https://github.com/Jeoxs/khanos/compare/v1.0.6...v1.0.7
[1.0.6]: https://github.com/Jeoxs/khanos/compare/v1.0.5...v1.0.6
[1.0.5]: https://github.com/Jeoxs/khanos/compare/v1.0.4...v1.0.5
[1.0.4]: https://github.com/Jeoxs/khanos/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/Jeoxs/khanos/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/Jeoxs/khanos/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/Jeoxs/khanos/compare/v1.0...v1.0.1
[1.0]: https://github.com/Jeoxs/khanos/releases/v1.0

[Unreleased]: https://github.com/Jeoxs/khanos/compare/v1.0...HEAD
