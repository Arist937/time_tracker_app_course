import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class ResetPasswordFormModel with EmailAndPasswordValidator, ChangeNotifier {
  ResetPasswordFormModel({@required this.auth, this.email = ''});
  final AuthBase auth;
  String email;

  void resetPassword() {
    try {
      auth.resetPassword(this.email);
      print(email);
      print(this.email);
    } catch (e) {
      rethrow;
    }
  }

  bool get canSubmit {
    return emailValidator.isValid(email);
  }

  void updateWith({
    String email,
  }) {
    this.email = email ?? this.email;
    notifyListeners();
  }
}
