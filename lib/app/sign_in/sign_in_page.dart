import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/loading_screen.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  Future<void> _signInAnonymously(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: false,
      builder: (context) => LoadingPage(),
    ));

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final userCredential = await auth.signInAnonymously();
      print(userCredential.uid);
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 48),
          SocialSignInButton(
            text: "Sign in with Google",
            imgLink: 'images/google-logo.png',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8),
          SocialSignInButton(
            text: "Sign in with Facebook",
            imgLink: 'images/facebook-logo.png',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: _isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8),
          SignInButton(
            text: "Sign in with Email",
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: _isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8),
          Text(
            "or",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          SignInButton(
            text: "Go Anonymous",
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: _isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
}
