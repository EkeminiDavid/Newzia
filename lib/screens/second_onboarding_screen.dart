import 'package:flutter/material.dart';
import 'package:newzia/constant.dart';
import 'package:newzia/helpers/custombutton.dart';
import 'package:newzia/helpers/texthelper.dart';
import 'package:newzia/screens/login.dart';

class SecondOnboardingScreen extends StatelessWidget {
  static const id = 'second onboarding screen';

  const SecondOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/newzia_header_logo1.png',
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Skip',
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                height: 688,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/women.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                height: 688,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      kNewziaBlue.withOpacity(1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TextLabel(
                      text: 'Get the latest news from',
                      color: kNewziaSurfaceWhite,
                    ),
                    const TextLabel(
                      text: 'reliable sources.',
                      color: kNewziaRed,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 20,
                      ),
                      height: 4,
                      color: kNewziaRed,
                    ),
                    RoundedButton(
                      onPress: () {
                        Navigator.pushNamed(
                          context,
                          LoginScreen.id,
                        );
                      },
                      title: 'Next',
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
