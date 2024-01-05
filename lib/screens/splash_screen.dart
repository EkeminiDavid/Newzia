import 'package:flutter/material.dart';
import 'package:newzia/screens/second_onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splash screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoOpacity = 0.0;
  double _imageOpacity = 0.0;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((_) {
      setState(() => _logoOpacity = 1.0);
    });
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() => _imageOpacity = 1.0);
    });
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, SecondOnboardingScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: _logoOpacity,
              duration: const Duration(microseconds: 1600),
              child: Column(
                children: [
                  const SizedBox(
                    height: 350,
                  ),
                  Image.asset('assets/newzia_logo.png'),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset('assets/newzia.png'),
                ],
              ),
            ),
          ),
          Row(
            children: [
              AnimatedOpacity(
                opacity: _imageOpacity,
                duration: const Duration(milliseconds: 1600),
                child: Image.asset('assets/splash_screen_image.png'),
              )
            ],
          )
        ],
      ),
    );
  }
}
