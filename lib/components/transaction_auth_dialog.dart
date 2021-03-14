import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatefulWidget {
  final Function(String password) onConfirm;

  const TransactionAuthDialog({Key key, @required this.onConfirm})
      : super(key: key);

  @override
  _TransactionAuthDialogState createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Authenticate'),
      content: TextField(
        controller: _passwordController,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide())),
        textAlign: TextAlign.center,
        obscureText: true,
        maxLength: 4,
        keyboardType: TextInputType.number,
        style: TextStyle(
          letterSpacing: 24.0,
          fontSize: 64.0,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            widget.onConfirm(_passwordController.text);
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
