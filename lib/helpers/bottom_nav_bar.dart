import 'package:flutter/material.dart';
import 'package:newzia/screens/bookmark.dart';
import 'package:newzia/screens/home.dart';
import 'package:newzia/screens/search.dart';

class BottomNavBar extends StatelessWidget {
  final int index;
  const BottomNavBar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != HomeScreen.id) {
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              },
              icon: const Icon(Icons.home_filled)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != SearchScreen.id) {
                  Navigator.pushReplacementNamed(context, SearchScreen.id);
                }
              },
              icon: const Icon(Icons.search_rounded)),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name !=
                    BookmarkScreen.id) {
                  Navigator.pushReplacementNamed(context, BookmarkScreen.id);
                }
              },
              icon: const Icon(Icons.bookmark_border_rounded)),
          label: 'Bookmark',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
              onPressed: () {}, icon: const Icon(Icons.person_outline)),
          label: 'Profile',
        ),
      ],
    );
  }
}
