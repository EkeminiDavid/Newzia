class PublishAt {
  static String getPublishTime(String publishAt) {
    DateTime apiDate = DateTime.parse(publishAt);
    DateTime now = DateTime.now();
    Duration difference = now.difference(apiDate);

    int days = difference.inDays;
    int hours = difference.inHours.remainder(24);
    int minutes = difference.inMinutes.remainder(60);

    if (days > 0) {
      return '$days day(s) ago';
    } else if (hours > 0) {
      return '$hours hour(s) ago';
    } else if (minutes > 0) {
      return '$minutes minute(s) ago';
    } else {
      return 'Just a moment ago';
    }
  }
}
