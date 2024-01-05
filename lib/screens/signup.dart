import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:newzia/constant.dart';
import 'package:newzia/helpers/custombutton.dart';
import 'package:newzia/helpers/texthelper.dart';
import 'package:newzia/screens/home.dart';
import 'package:newzia/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  static const id = 'Sign up screen';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? email, password, credentialError;
  bool ischecked = false;
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
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, LoginScreen.id);
                      },
                      child: const Text('Sign In'),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(kNewziaBlue),
                          foregroundColor:
                              MaterialStatePropertyAll(kNewziaBackgroundWhite)),
                      child: const Text('Sign Up'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const TextLabel(
                  text: "Create",
                  color: kNewziaBlue,
                ),
                const TextLabel(
                  text: "an account",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: ischecked,
                      onChanged: (newValue) {
                        setState(() {
                          ischecked = newValue!;
                        });
                      },
                      checkColor: kNewziaBlue,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      fillColor: const MaterialStatePropertyAll(kNewziaGray),
                    ),
                    const Text('I have read'),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        ' Terms & Agreement',
                        style: TextStyle(
                            color: kNewziaRed, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundedButton(
                  onPress: () async {
                    if (ischecked == false ||
                        email == null ||
                        password == null) {
                      return;
                    }

                    try {
                      setState(() {
                        _showModalProgress = true;
                      });
                      await _auth
                          .createUserWithEmailAndPassword(
                              email: email!, password: password!)
                          .then((value) {
                        Navigator.popAndPushNamed(context, HomeScreen.id);
                        setState(() {
                          _showModalProgress = false;
                        });
                      });
                    } on FirebaseAuthException catch (e) {
                      //TODO: implement catch mechaninism

                      setState(() {
                        _showModalProgress = false;
                        credentialError = e.code.replaceAll('-', ' ');
                      });
                    }
                  },
                  title: 'Sign Up',
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
