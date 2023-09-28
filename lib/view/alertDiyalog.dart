import 'package:flutter/material.dart';


class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function onPres;

  final String buttonText;
  final String? secondButtonText;
  final Function? onSecondPress;

  final Color? textColor;

  CustomAlertDialog({
    required this.title,
    required this.message,
    required this.onPres,
    required this.buttonText,
    this.secondButtonText,
    this.onSecondPress,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: TextStyle(color: textColor != null ? textColor : Colors.black),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.0),
            child: Text(message,
                textAlign: TextAlign.left, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            onPres();
          },
          child: Text(buttonText),
        ),
        if (secondButtonText != null && onSecondPress != null)
          TextButton(
            onPressed: () {
              onSecondPress!();
            },
            child: Text(secondButtonText!),
          ),
      ],
    );
  }
}
