import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.title = 'Nothing here',
    this.message = 'Add a job to get started!',
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 32.0,
            color: Colors.black54,
          ),
        ),
        Text(
          message,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}