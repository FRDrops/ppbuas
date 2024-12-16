import "package:flutter/material.dart";
import "package:pbb/screens/login_screen.dart";
import "package:pbb/services/auth_service.dart";
import "package:pbb/utils/appvalidator.dart";
//ignore_for_file: prefer_const_constructors

class SignUpView extends StatefulWidget{
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm () async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
    }
    var data = {
        "username": _userNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "phone": _phoneController.text,
        'remainingAmount': 0,
        'totalCredit': 0,
        'totalDedit': 0,
      };

      await authService.createUser(data, context);
      setState(() {
        isLoader = false;
      });

    // if (_formKey.currentState!.validate()) {
    //   ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
    //     const SnackBar(content: Text('Berhasil di Submit'),),
    //   );
    // }
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
              child: Text("Buat Akun Baru",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28,
              fontWeight: FontWeight.bold),),
            ),
            SizedBox(
              height: 40.0,
            ),
            TextFormField(
              controller:  _userNameController,
              autovalidateMode: 
              AutovalidateMode.onUserInteraction,
              decoration: _buildInputDecoration("Username", Icons.person),
              validator: appValidator.validateUsername,
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
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              autovalidateMode: 
              AutovalidateMode.onUserInteraction,
              decoration: _buildInputDecoration("Nomor Telepon", Icons.call),
              validator: appValidator.validatePhoneNumber
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
                Text("Create", style: TextStyle(fontSize: 20),)),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton(onPressed: (){
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => LoginView()),
              );
            }, 
            child: Text(
              "Login",
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
