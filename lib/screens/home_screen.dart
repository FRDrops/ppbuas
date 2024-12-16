import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbb/screens/login_screen.dart';
import 'package:pbb/widget/add_transaction_form.dart';
import 'package:pbb/widget/hero_card.dart';
import 'package:pbb/widget/transactions_card.dart';
//ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoading = false;

  logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => LoginView())));
  }

  _dialogBuilder(BuildContext) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: AddTransactionForm(),
          );
        });
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[900],
          onPressed: (() {
            _dialogBuilder(context);
          }),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          title: Text(
            "Hello",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  logOut();
                },
                icon: isLogoutLoading
                    ? CircularProgressIndicator()
                    : Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ))
          ],
        ),
        body: Column(children: [
          HeroCard(
            userId: userId,
          ),
          TransactionsCard(),
        ]));
  }
}
