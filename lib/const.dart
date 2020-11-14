/// Has all urls used in the app as static const strings.
class Const {
  //Base Hacker News URL
  static const String hackerNewsBaseUrl =
      'https://hacker-news.firebaseio.com/v0';

  static const placeholderStr = '%%';

  //stories urls
  static const newStories = '$hackerNewsBaseUrl/newstories.json';
  static const topStories = '$hackerNewsBaseUrl/topstories.json';
  static const bestStories = '$hackerNewsBaseUrl/beststories.json';
  static const jobStories = '$hackerNewsBaseUrl/jobstories.json';
  static const showStories = '$hackerNewsBaseUrl/showstories.json';
  static const askStories = '$hackerNewsBaseUrl/askstories.json';

  // Share details message
  static const shareDetails = '#simplehknews';

  // About page
  static const authorProfile = 'https://twitter.com/thuongleit';
  static const emailAddress = 'thuongle.it@gmail.com';
  static const emailSubject = 'About Simple Hacker News!';

  static const changelog =
      'https://raw.githubusercontent.com/thuongleit/hackernews_flutter/master/CHANGELOG.md';
  static const appSource = 'https://github.com/thuongleit/hackernews_flutter';
  static const apiSourceName = "HackerNews API";
  static const apiSource = 'https://github.com/HackerNews/API';
  static const flutterPage = 'https://flutter.dev';
  static const author = "Thuong Le";
}
