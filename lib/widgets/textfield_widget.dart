import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const TextFieldWidget(this.controller, this.label, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please fill the field.";
        }
        return null;
      },
    );
  }
}
