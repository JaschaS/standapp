import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:standapp/standapp/host_screen/host_screen_widget.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInPage extends StatefulWidget {
  final String title = 'Sign In & Out';

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  User? user;

  @override
  void initState() {
    _auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    if (user != null) {
      return HostScreenWidget(user!);
    }

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
      final UserCredential userCredential =
          await _auth.signInWithPopup(googleProvider);

      user = userCredential.user;

      if (user == null)
        throw Exception("No user was found in user-credentials");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HostScreenWidget(user!)),
      );
    } catch (e) {
      print(e);
    }
  }
}
