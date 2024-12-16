import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pbb/screens/dashboard.dart';
import 'package:pbb/screens/login_screen.dart';
import 'package:pbb/screens/sign_up.dart';
//ignore_for_file: prefer_const_constructors
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignUpView();
          }
          return LoginView();
        });
  }
}
