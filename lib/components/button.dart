

import 'package:flutter/material.dart';
class MyButton extends StatelessWidget {
  MyButton({super.key,required this.text,required this.color,required this.function});
final VoidCallback function;
 final Color color;
  final String text;



  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed:function,
    child: Text(text,style: TextStyle(color: Colors.white),),
      color: color,
minWidth: 240,
      height: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14)
      ),

    );
  }
}
