import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newzia/helpers/bottom_nav_bar.dart';
import 'package:newzia/helpers/categorynews_helper.dart';
import 'package:newzia/helpers/news_helper.dart';
import 'package:newzia/helpers/world_news_widget.dart';
import 'package:newzia/models/articles.dart';
import 'package:newzia/screens/custom_display.dart';
import 'package:newzia/screens/second_onboarding_screen.dart';

User? loggedInUser;
final currentUser = loggedInUser?.email;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  static const id = 'home screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, List<Article>> newsMap = {
    'General': [],
    'Health': [],
    'Entertainment': [],
    'Business': [],
    'Technology': [],
    'Sports': [],
    'politics': []
  };
  List<Article> articles = [];
  int _activeIndex = 0;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _loading = true;

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

  void getNews() async {
    News news = News();
    var getWorldNews = await news.getWorldNewsCategory();
    var getCategoryNews = await news.getCategoryNews();
    setState(() {
      articles = getWorldNews;
      newsMap = getCategoryNews;

      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getNews();
    _tabController = TabController(vsync: this, length: newsMap.length);
    _tabController!.addListener(() {
      setState(() {
        _activeIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  //TODO: final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: newsMap.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Image.asset('assets/newzia_header_logo1.png'),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.popUntil(context,
                        (ModalRoute.withName(SecondOnboardingScreen.id)));
                  });
                },
                icon: const Icon(Icons.lock_outline_rounded))
          ],
        ),
        bottomNavigationBar: const BottomNavBar(
          index: 0,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : newsMap.isEmpty || articles.isEmpty
                ? const CustomNotificationDisplay(text: 'No result')
                : ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: articles.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var article = articles[index];
                            return WorldNewsView(
                              title: article.title,
                              articleUrl: article.articleUrl,
                              isBookmarked: article.isBookmarked,
                              source: article.source,
                              urlToImage: article.urlToImage,
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
                      CategoryNews(
                        activeTab: _activeIndex,
                        tabController: _tabController!,
                        categoryNews: newsMap,
                      )
                    ],
                  ),
      ),
    );
  }
}
