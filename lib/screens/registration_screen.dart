import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../components/text_button_widget.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextfieldDecoration.copyWith(
                  hintText: 'Enter your Email',
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextfieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              TextButtonWidget(
                color: Colors.blueAccent,
                onPressed: () async {
                  // print(email);
                  // print(password);
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email!,
                      password: password!,
                    );

                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                contextText: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
