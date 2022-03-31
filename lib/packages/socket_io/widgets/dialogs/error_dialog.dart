import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.error_outline_sharp, color: Colors.red),
          Padding(
            padding: EdgeInsets.only(left: 15),
          ),
          Text('Connection Failed!'),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Please check your OBD Device connection'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
