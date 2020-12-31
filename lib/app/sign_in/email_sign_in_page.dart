import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page_form.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Sign In"),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(auth: auth),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
