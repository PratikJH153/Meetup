import 'package:flutter/material.dart';

class GlobalLoader extends StatelessWidget {
  Color? color;
  GlobalLoader({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: color??Colors.blue));
  }
}
