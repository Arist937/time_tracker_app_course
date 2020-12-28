import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

// stateful widget to hold whether user has signed in or not
class LandingPage extends StatefulWidget {
  const LandingPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  // check if the user is logged in already to skip sign in page
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  // updates the current user
  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        auth: widget.auth,
        onSignIn: (user) => _updateUser(user),
      );
    } else {
      return HomePage(
        auth: widget.auth,
        onSignOut: () => _updateUser(null),
      );
    }
  }
}
