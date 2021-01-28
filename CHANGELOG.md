# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Release iOS app

## [2.1.0] - 2021-01-08

### Added

- Support different reading mode when browsing stories: Title only, Minimalist, With content

### Fixed

- Lagging when scrolling (to the top/bottom) or holding in stories tab.
- Pull-to-refresh function in comments screen didn't work.
- Posting a comment didn't appear immediately.

## [2.0.0] - 2020-11-14

### Added

- Login/Logout with Hacker News account.
- Swipe gesture with swipe left/right to save, upvote, reply to a comment.
- Upvote a story/comment with a logged-in Hacker News account.
- View comments with collapsible and by-level thread.
- Add a comment or reply to a comment.
- Tap-to-collapse feature on a comment thread.
- Popup menu context by long pressing on story and comment.
- Share story article link, hacker news link, or share a comment.
- Shimmer loading animation effect.
- Splash screen.
- Firebase Crashlytics.
- Github Actions CI.

### Changed

- Applied bloc library (https://bloclibrary.dev) for state management.
- Refactor app architecture and project structure.
- New redesign app launcher icon.
- Change target SDK to level 29.

### Fixed

- The black title text color was broken in Dart/Black mode.

### Removed

- BaseProvider and the usage of provider package.

## [1.2.1] - 2020-10-24

### Added

- Saved stories to read later.
- Swipe on the story row to save it.

### Fixed

- Various bug fixes.

## [1.1.0] - 2020-09-17

### Added

- 'About' screen to show information about the app.
- 'Settings' screen to set up the app's theme and choose a browser option (internal/external) to open an URL.
- 'Best' stories tab on the home screen.

### Fixed

- Various bug fixes.

## [1.0.0] - 2020-08-31

### Added

- Initial project.
- First release version.

[unreleased]: https://github.com/thuongleit/MinimalistHackerNews/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/thuongleit/MinimalistHackerNews/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/thuongleit/MinimalistHackerNews/compare/v1.2.1...v2.0.0
[1.2.1]: https://github.com/thuongleit/MinimalistHackerNews/compare/v1.1.0...v1.2.1
[1.1.0]: https://github.com/thuongleit/MinimalistHackerNews/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/thuongleit/MinimalistHackerNews/releases/tag/v1.0.0
