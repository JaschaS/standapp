import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/widgets/background_widget.dart';
import 'package:standapp/standapp/standapp_colors.dart';

class EmailSignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final userName = _userNameController.text;
    final password = _passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userName,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email') {
        _setEmailAndPasswordError("Email must be a valid email address", null);
      } else if (e.code == 'wrong-password') {
        _setEmailAndPasswordError(
          null,
          "Sorry, wrong password. Please try again",
        );
      } else if (e.code == 'user-not-found') {
        _setEmailAndPasswordError("User not found", null);
      }
    } catch (e) {
      print(e);
    }
  }

  void _setEmailAndPasswordError(final String? email, final String? password) {
    setState(() {
      _emailError = email;
      _passwordError = password;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 150),
      child: BackgroundWidget(
        child: Center(
          child: SizedBox(
            width: 250,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_circle),
                    hintText: 'Email',
                    errorText: _emailError,
                  ),
                  controller: _userNameController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    errorText: _passwordError,
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: AppColors.red),
                      onPressed: _login,
                      child: Text("login"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
