class Article {
  String title;
  String source;
  String urlToImage;
  String publishAt;
  String articleUrl;
  bool isBookmarked;
  String? documentId;

  Article({
    this.isBookmarked = false,
    this.documentId,
    required this.publishAt,
    required this.title,
    required this.source,
    required this.urlToImage,
    required this.articleUrl,
  });

  toggleIsBookmark() {
    isBookmarked = !isBookmarked;
  }
}
