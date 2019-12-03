import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({this.title, this.color, @required this.onPressed});
  final Color color;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(1.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 150.0,
          height: 52.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}