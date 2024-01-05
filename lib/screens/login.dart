import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:newzia/constant.dart';
import 'package:newzia/helpers/custombutton.dart';
import 'package:newzia/helpers/texthelper.dart';
import 'package:newzia/screens/home.dart';
import 'package:newzia/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? email, password, credentialError;
  bool _showModalProgress = false;
  bool passwordToggled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _showModalProgress,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(kNewziaBlue),
                          foregroundColor:
                              MaterialStatePropertyAll(kNewziaBackgroundWhite)),
                      child: const Text('Sign In'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, SignupScreen.id);
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const TextLabel(
                  text: "Let's Sign",
                  color: kNewziaBlue,
                ),
                const TextLabel(
                  text: "You In",
                  color: kNewziaBlue,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  onChanged: (inputText) {
                    email = inputText;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: customInputDecoration().copyWith(
                    hintText: 'Enter your email',
                    suffixIcon: const Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (inputText) {
                    password = inputText;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  decoration: customInputDecoration().copyWith(
                    errorText: credentialError,
                    hintText: '******',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordToggled = !passwordToggled;
                        });
                      },
                      icon: passwordToggled
                          ? const Icon(Icons.visibility_off_outlined)
                          : const Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                  obscureText: passwordToggled,
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'forget password?',
                    style: TextStyle(
                        color: kNewziaLynch, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundedButton(
                  onPress: () async {
                    if (email == null || password == null) {
                      return;
                    }

                    try {
                      setState(() {
                        _showModalProgress = true;
                      });

                      await _auth
                          .signInWithEmailAndPassword(
                        email: email!,
                        password: password!,
                      )
                          .then((value) {
                        Navigator.popAndPushNamed(context, HomeScreen.id);
                        setState(() {
                          _showModalProgress = false;
                        });
                      });
                    } on FirebaseAuthException catch (e) {
                      //TODO: Implement error check mechanism
                      setState(() {
                        _showModalProgress = false;
                        credentialError = e.code.replaceAll('-', ' ');
                      });
                    }
                  },
                  title: 'Sign In',
                  buttonHorizontalPadding: 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
