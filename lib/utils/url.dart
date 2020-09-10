/// Has all urls used in the app as static const strings.
class Url {
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

  //item detail url
  static const itemUrl = "$hackerNewsBaseUrl/item/$placeholderStr.json";

  // story item browsing url
  static const itemBrowsingUrl = 'https://news.ycombinator.com';

  // vote an item url
  static const itemVoteUrl = '$itemBrowsingUrl/vote?id=$placeholderStr&how=up';

  // content of an item url
  static const itemContentUrl = '$itemBrowsingUrl/item?id=$placeholderStr';

  // Share details message
  static const shareDetails = '#simplehknews';

  // About page
  static const authorProfile = 'https://twitter.com/thuongleit';
  static const authorPatreon = 'https://www.patreon.com/thuongleit';
  static const emailAddress = 'thuongle.it@gmail.com';
  static const emailSubject = 'About Simple Hacker News!';

  static const changelog =
      'https://raw.githubusercontent.com/thuongleit/hackernews_flutter/master/CHANGELOG.md';
  static const appSource = 'https://github.com/thuongleit/hackernews_flutter';
  static const apiSource = 'https://github.com/HackerNews/API';
  static const flutterPage = 'https://flutter.dev';
}

String getRightUrl(String tempUrl, String replace) => tempUrl.replaceAll(Url.placeholderStr, replace);
