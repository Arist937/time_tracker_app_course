import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class ResetPasswordForm extends StatefulWidget with EmailAndPasswordValidator {
  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  String get _email => _emailController.text;

  Future<void> _resetPassword(String email) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    try {
      auth.resetPassword(email);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _buildChildren(context),
      ),
    );
  }

  List<Widget> _buildChildren(context) {
    return [
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: "Enter your Email",
          hintText: "test@email.com",
        ),
        onChanged: (email) => _updateState(),
      ),
      SizedBox(height: 8),
      FormSubmitButton(
        text: "Reset my password",
        onPressed: widget.emailValidator.isValid(_email)
            ? () => _resetPassword(_email)
            : null,
      )
    ];
  }

  _updateState() {
    setState(() {});
  }
}
