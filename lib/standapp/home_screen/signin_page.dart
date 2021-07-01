import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final String title = 'Sign In & Out';

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 250,
          child: ElevatedButton(
            child: ListTile(
              leading: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    image: AssetImage(
                      'assets/logos/google_dark.png',
                      package: 'flutter_signin_button',
                    ),
                    height: 36.0,
                  ),
                ),
              ),
              tileColor: const Color(0xFF4285F4),
              title: Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: _signInWithGoogle,
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      await _auth.signInWithPopup(googleProvider);
    } catch (e) {
      print(e);
    }
  }
}
