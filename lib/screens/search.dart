import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newzia/constant.dart';
import 'package:newzia/helpers/bottom_nav_bar.dart';
import 'package:newzia/helpers/news_tile.dart';
import 'package:newzia/models/articles.dart';
import 'package:newzia/screens/custom_display.dart';

User? loggedInUser;
final currentUser = loggedInUser?.email;

class SearchScreen extends StatefulWidget {
  static const id = 'search screen';

  const SearchScreen({super.key});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _searchController = TextEditingController();
  List<Article> _articles = [];
  bool _isLoading = false;
  String _error = '';

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future<void> _fetchArticles(String query) async {
    List<Article> articles = [];
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$query&sortBy=relevancy&sortBy=popularity&sortBy=publishedAt&language=en&apiKey=$kApiKey'); // Replace with your API endpoint
    try {
      final response = await http.get(url);

      var jsonData = jsonDecode(response.body);

      if (jsonData['status'] == "ok") {
        jsonData['articles'].forEach((article) {
          Article newArticle = Article(
            title: article['title'] ?? '',
            source: article['author'] ?? '',
            urlToImage: article['urlToImage'] ?? '',
            publishAt: article['publishedAt'] ?? '',
            articleUrl: article["url"] ?? '',
          );

          articles.add(newArticle);
        });
        setState(() {
          _articles = articles;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to fetch articles';
        });
      }
    } catch (error) {
      setState(() {
        _error = 'An error occurred';
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          surfaceTintColor: kNewziaBackgroundWhite,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Text(
                'Discovery',
                style: TextStyle(
                    color: kNewziaBlue,
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
      bottomNavigationBar: const BottomNavBar(index: 1),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _searchController,
              decoration: customInputDecoration().copyWith(
                hintText: 'Search for news',
                suffixIcon: IconButton(
                  onPressed: () {
                    _fetchArticles(_searchController.text);
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.search_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? CustomNotificationDisplay(
                        text: _error,
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: ListView.builder(
                          itemCount: _articles.length,
                          itemBuilder: (context, index) {
                            var article = _articles[index];
                            return NewsTile(
                              articleTitle: article.title,
                              articleSource: article.source,
                              articleUrl: article.articleUrl,
                              imageUrl: article.urlToImage,
                              isBookmarked: false,
                              publishAt: article.publishAt,
                              onPressed: () async {
                                if (!article.isBookmarked) {
                                  try {
                                    await _firestore
                                        .collection('bookmarks')
                                        .add({
                                      'user': currentUser,
                                      'article source': article.source,
                                      'article title': article.title,
                                      'published time': article.publishAt,
                                      'timestamp': FieldValue.serverTimestamp(),
                                      'url to article': article.articleUrl,
                                      'url to image': article.urlToImage,
                                    }).then(
                                      (documentReference) {
                                        article.documentId =
                                            documentReference.id;

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
                                        article.isBookmarked =
                                            !article.isBookmarked;
                                      });
                                    });
                                  } on FirebaseException catch (e) {
                                    print(e.code);
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
