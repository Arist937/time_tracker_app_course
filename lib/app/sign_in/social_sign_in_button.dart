import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String text,
    @required String imgLink,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        assert(imgLink != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(imgLink),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(imgLink),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
