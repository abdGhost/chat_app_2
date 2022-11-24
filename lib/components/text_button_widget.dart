import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  Color? color;
  void Function()? onPressed;
  String? contextText;

  TextButtonWidget({
    this.color,
    @required this.onPressed,
    this.contextText,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            contextText!,
            style:const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
