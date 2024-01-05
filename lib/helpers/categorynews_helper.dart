import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newzia/constant.dart';
import 'package:newzia/helpers/news_tile.dart';
import 'package:newzia/models/articles.dart';
import 'package:newzia/screens/home.dart';

class CategoryNews extends StatefulWidget {
  const CategoryNews({
    super.key,
    required this.activeTab,
    required this.tabController,
    required this.categoryNews,
  });

  final TabController tabController;
  final Map<String, List> categoryNews;
  final int activeTab;

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TabBar(
            padding: const EdgeInsets.all(5),
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: const Border()),
            controller: widget.tabController,
            isScrollable: true,
            tabs: widget.categoryNews.keys
                .map(
                  (category) => MyCustomTab(
                    text: category,
                    isSelected: widget.activeTab ==
                        widget.categoryNews.keys.toList().indexOf(category),
                  ),
                )
                .toList(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
                controller: widget.tabController,
                children: widget.categoryNews.keys.map((category) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.categoryNews[category]!.length,
                    itemBuilder: (context, index) {
                      Article article = widget.categoryNews[category]![index];

                      return NewsTile(
                        articleTitle: article.title,
                        articleSource: article.source,
                        articleUrl: article.articleUrl,
                        imageUrl: article.urlToImage,
                        isBookmarked: article.isBookmarked,
                        publishAt: article.publishAt,
                        onPressed: () async {
                          if (!article.isBookmarked) {
                            try {
                              await _firestore.collection('bookmarks').add({
                                'user': currentUser,
                                'article source': article.source,
                                'article title': article.title,
                                'published time': article.publishAt,
                                'timestamp': FieldValue.serverTimestamp(),
                                'url to article': article.articleUrl,
                                'url to image': article.urlToImage,
                              }).then(
                                (documentReference) {
                                  article.documentId = documentReference.id;

                                  setState(() {
                                    article.isBookmarked =
                                        !article.isBookmarked;
                                  });
                                },
                              );
                            } on FirebaseException catch (e) {
                              print('error occur: ${e.code}');
                            }
                          } else {
                            try {
                              await _firestore
                                  .collection('bookmarks')
                                  .doc(article.documentId)
                                  .delete()
                                  .then((value) {
                                setState(() {
                                  article.isBookmarked = !article.isBookmarked;
                                });
                              });
                            } on FirebaseException catch (e) {
                              print(e.code);
                            }
                          }
                        },
                      );
                    },
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }
}

class MyCustomTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const MyCustomTab({super.key, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? kNewziaBlue : Colors.transparent,
        borderRadius:
            BorderRadius.circular(16), // Adjust borderRadius as desired
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? kNewziaSurfaceWhite : kNewziaBlue,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}
