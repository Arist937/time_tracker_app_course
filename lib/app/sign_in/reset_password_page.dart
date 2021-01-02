import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/reset_password_form.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: ResetPasswordForm(),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
