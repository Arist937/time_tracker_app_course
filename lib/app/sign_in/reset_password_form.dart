import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/reset_password_form_model.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key key, @required this.model}) : super(key: key);
  final ResetPasswordFormModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ResetPasswordFormModel>(
      create: (_) => ResetPasswordFormModel(auth: auth),
      child: Consumer<ResetPasswordFormModel>(
        builder: (_, model, __) => ResetPasswordForm(model: model),
      ),
    );
  }

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      widget.model.resetPassword();
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
        onChanged: (email) => widget.model.updateWith(email: email),
      ),
      SizedBox(height: 8),
      FormSubmitButton(
        text: "Reset my password",
        onPressed: _resetPassword,
      )
    ];
  }
}
