import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/reset_password_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  bool _submitted = false;
  bool _isLoading = false;

  void _emailEditingComplete() {
    final newfocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newfocus);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmail(_email, _password);
      } else {
        await auth.createEmailAccount(_email, _password);
      }

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Sign in Failed",
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleForm() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? _formType = EmailSignInFormType.register
          : _formType = EmailSignInFormType.signIn;
      _submitted = false;
    });

    _emailController.clear();
    _passwordController.clear();
  }

  void _forgotPassword(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: true, builder: (context) => ResetPasswordPage()),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? "Sign In"
        : "Create an account";

    final secondaryText = _formType == EmailSignInFormType.signIn
        ? "Need an account? Tap here to register."
        : "Have an account? Tap here to login";

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(height: 8),
      _buildPasswordTextField(),
      SizedBox(height: 8),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8),
      FlatButton(
        onPressed: !_isLoading ? _toggleForm : null,
        child: Text(secondaryText),
      ),
      FlatButton(
        onPressed: () => _forgotPassword(context),
        child: Text("Forgot your password? Tap here to reset"),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool validPassword = widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        errorText:
            validPassword || !_submitted ? null : widget.passwordErrorText,
        enabled: !_isLoading,
      ),
      focusNode: _passwordFocusNode,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildEmailTextField() {
    bool validEmail = widget.emailValidator.isValid(_email);

    return TextField(
      controller: _emailController,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "example@email.com",
        errorText: validEmail || !_submitted ? null : widget.emailErrorText,
        enabled: !_isLoading,
      ),
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(context),
      ),
    );
  }

  _updateState() {
    setState(() {});
  }
}
