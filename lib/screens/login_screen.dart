
import 'package:flutter/material.dart';
import 'package:pbb/screens/sign_up.dart';
import 'package:pbb/services/auth_service.dart';
import 'package:pbb/utils/appvalidator.dart';
//ignore_for_file: prefer_const_constructors

// ignore: must_be_immutable
class LoginView extends StatefulWidget{
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;
  var authService = AuthService();
  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoader = true;
    });

    var data = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    // Make sure this runs on the main thread
    await Future.delayed(Duration(milliseconds: 0), () async {
      await authService.login(data, context);
    });

    setState(() {
      isLoader = false;
    });
  }


}

  var appValidator = Appvalidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF90D5FF),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
          children: [
            SizedBox(
              height: 60.0,
            ),
            SizedBox(
              width: 250,
              child: Text("Login Akun",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28,
              fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 40.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: 
              AutovalidateMode.onUserInteraction,
              decoration: _buildInputDecoration("Email", Icons.email),
              validator: appValidator.validateEmail,
            ),
            SizedBox(
              height: 16.0,
            ),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.phone,
              autovalidateMode: 
              AutovalidateMode.onUserInteraction,
              decoration: _buildInputDecoration("Password", Icons.lock),
              validator: appValidator.validatePassword
            ),
            SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: 
              ElevatedButton(
                onPressed: (){
                  isLoader ? print("Loading"): _submitForm();},
                child: 
                isLoader ? 
                Center(child: CircularProgressIndicator()):
                Text("Login", style: TextStyle(fontSize: 20),)),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton(onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => SignUpView()),
              );
            }, 
            child: Text(
              "Create New Account",
              style: TextStyle(color: Colors.white, 
              fontSize: 20),
            ))
          ],
        )),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon){
    return InputDecoration(
      fillColor: Color(0xFFF2F0EF),
      filled: true,
      labelText: label,
      suffixIcon: Icon(suffixIcon),
      border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0)));
  }
}
