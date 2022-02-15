import 'package:flutter/material.dart';

class MenuItem{
  String text;
  IconData? icon;

  MenuItem({required this.text,required this.icon});
}

class MenuItems{

  static List<MenuItem> items = [
    itemCopy,
    itemDelete
  ];

  static MenuItem itemDelete = MenuItem(
    text: "Delete",
    icon: Icons.delete
  );

  static MenuItem itemCopy = MenuItem(
    text: "Copy Text",
    icon: Icons.copy
  );

}
