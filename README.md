[![build](https://github.com/thuongleit/MinimalistHackerNews/workflows/Flutter%20CI/badge.svg?branch=master)][Build Status]
[![license](https://img.shields.io/github/license/thuongleit/MinimalistHackerNews)][License]
[![release](https://img.shields.io/github/v/release/thuongleit/MinimalistHackerNews?include_prereleases)][Release version]

<p align="center">
  <img src="https://raw.githubusercontent.com/thuongleit/MinimalistHackerNews/master/screenshots/icon.png" width="200" alt="HKNews">
</p>
<h2 align="center">Yet another Hacker News Reader</h2>

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=vifi.services.hknews&referrer=utm_source%3Dgithub
">
    <img src="https://play.google.com/intl/en_us/badges/images/badge_new.png" alt="Play Store">
  </a>
</p>

[The app - HKNews][Play Store] is a Hacker News reader client for Android and iOS, uses
official [Hacker News API].

The project is built using the [Flutter] framework. The project aims
to build a simple, fast, and ad-free application, designed for minimalists.

<!-- [![Get it on Google Play][Play Store Badge]][Play Store] -->

## Features

- Browse newest, best, top stories, jobs, show, ask from Hacker News.
- Readability option with internal/external browser support.
- Simplicity design for the minimalists.
- Swift reading by scanning title.
- Save stories to read later.
- Dark/black mode to taking care of your eyes.
- Login with Hacker News account.
- Upvote and post/reply to comments.
- Collapsible comments thread and tap-to-collapse feature.
- Gesture support with swipe left/right on a story/comment.
- Share stories and comments easily.

## Upcoming features

See the [CHANGELOG] file for more details.

## Development

Make sure you have Flutter installed on your local machine. For more
instructions on how to install flutter, look [here][Flutter installation].

<!-- The app is using Firebase Crashlytics service. Create a Firebase project using -->
<!-- the [Firebase Developer Console]. Then setting up Configure the project with -->
<!-- `google-services.json` -->

```
git clone https://github.com/thuongleit/MinimalistHackerNews.git
cd MinimalistHackerNews
flutter run
```

## Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/thuongleit/MinimalistHackerNews/master/screenshots/device-1.png" width="256" hspace="4">
  <img src="https://raw.githubusercontent.com/thuongleit/MinimalistHackerNews/master/screenshots/device-2.png" width="256" hspace="4">
  <img src="https://raw.githubusercontent.com/thuongleit/MinimalistHackerNews/master/screenshots/device-3.png" width="256" hspace="4">
</p>

## Maintainers

- [Thuong Le](https://github.com/thuongleit)

## Contributing

Issues and pull requests are always welcome.

## License

This project is distributed under the Apache License 2.0 as specified in [LICENSE].


[Build Status]: https://github.com/thuongleit/MinimalistHackerNews/actions?query=workflow%3A%22Flutter+CI%22
[License]: https://github.com/thuongleit/MinimalistHackerNews/blob/master/LICENSE
[Release version]: https://github.com/thuongleit/MinimalistHackerNews/releases
[Changelog]: https://github.com/thuongleit/MinimalistHackerNews/blob/master/CHANGELOG.md
[Play Store]: https://play.google.com/store/apps/details?id=vifi.services.hknews&referrer=utm_source%3Dgithub
[Play Store Badge]: https://play.google.com/intl/en_us/badges/images/badge_new.png
[Hacker News API]: https://github.com/HackerNews/API
[Flutter]: https://flutter.dev
[Flutter installation]: https://flutter.io/docs/get-started/install
[Firebase Developer Console]: https://console.firebase.google.com
