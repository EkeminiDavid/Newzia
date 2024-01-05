import 'package:flutter/material.dart';
import 'package:newzia/screens/arcticle_view.dart';
import 'package:newzia/screens/bookmark.dart';
import 'package:newzia/screens/home.dart';
import 'package:newzia/constant.dart';
import 'package:newzia/screens/login.dart';
import 'package:newzia/screens/search.dart';
import 'package:newzia/screens/second_onboarding_screen.dart';
import 'package:newzia/screens/signup.dart';
import 'package:newzia/screens/splash_screen.dart';

class Newzia extends StatelessWidget {
  const Newzia({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Newzia',
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignupScreen.id: (context) => const SignupScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ArticleScreen.id: (context) => const ArticleScreen(),
        SecondOnboardingScreen.id: (context) => const SecondOnboardingScreen(),
        SearchScreen.id: (context) => const SearchScreen(),
        BookmarkScreen.id: (context) => const BookmarkScreen()
      },
      theme: _kNewziaTheme,
    );
  }
}

final ThemeData _kNewziaTheme = _buildNewziaTheme();

ThemeData _buildNewziaTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: true);

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: kNewziaLynch,
      secondary: kNewziaGray,
      error: kNewziaRed,
    ),
    scaffoldBackgroundColor: kNewziaBackgroundWhite,
    textTheme: _buildNewziaTextTheme(base.textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: kNewziaBackgroundWhite,
      foregroundColor: kNewziaBlue,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kNewziaLynch,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kNewziaSurfaceWhite.withOpacity(0.6),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: kNewziaRed,
      elevation: 0,
      unselectedItemColor: kNewziaBlue,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: kNewziaBlue),
      fillColor: kNewziaGray,
      suffixIconColor: kNewziaLynch,
      prefixIconColor: kNewziaGray,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(15.0), // Adjust the value as needed
      ),
    ),
  );
}

TextTheme _buildNewziaTextTheme(TextTheme base) {
  return base
      .copyWith(
        headlineSmall: base.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        titleLarge: base.titleLarge!.copyWith(
          fontSize: 25.0,
        ),
        bodySmall: base.bodySmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        bodyLarge: base.bodyLarge!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      )
      .apply(
        fontFamily: 'Montserrat',
      );
}
