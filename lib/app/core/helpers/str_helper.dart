

class StrHelper {
  static String replace(String str, String search, String element) {
    return str.replaceAll(search, element);
  }

  static String cleanRoute(String route) {
    return replace(replace(route, '/', ''), '-', '_');
  }

  static String titleFromRoute(String route) {
    return cleanRoute(explode(route,'/').reversed.firstOrNull??'No title');
  }

  static List<String> explode(String string, String delimiter)
  {
    return string.split(delimiter);
  }
}
