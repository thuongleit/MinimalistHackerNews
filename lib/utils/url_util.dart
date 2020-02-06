/// Based on : http://grepcode.com/file/repository.grepcode.com/java/ext/com.google.android/android/2.3.3_r1/android/webkit/CookieManager.java#CookieManager.getBaseDomain%28java.lang.String%29
/// Get the base domain for a given host or url. E.g. mail.google.com will return google.com
String getBaseDomain(String url) {
  if (url == null || url.isEmpty) {
    return '';
  }

  var host = _getHost(url);

  var startIndex = 0;
  var nextIndex = host.indexOf('.');
  var lastIndex = host.lastIndexOf('.');
  while (nextIndex < lastIndex) {
    startIndex = nextIndex + 1;
    nextIndex = host.indexOf('.', startIndex);
  }

  return startIndex > 0 ? host.substring(startIndex) : host;
}

// Will take a url such as http://www.stackoverflow.com and return www.stackoverflow.com
String _getHost(String url){
  if (url == null || url.isEmpty) {
    return '';
  }

  var doubleslash = url.indexOf('//');
  if (doubleslash == -1) {
    doubleslash = 0;
  }else {
    doubleslash += 2;
  }

  var end = url.indexOf('/', doubleslash);
  end = end >= 0 ? end : url.length;

  var port = url.indexOf(':', doubleslash);
  if (port != null) {
    if (port > 0 && port < end) {
      end = port;
    }
  }

  return url.substring(doubleslash, end);
}