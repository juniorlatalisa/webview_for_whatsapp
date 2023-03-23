import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('AlertDialog Title 2'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('This is a demo alert dialog.'),
            Text('Would you like to approve of this message?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Approve'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
