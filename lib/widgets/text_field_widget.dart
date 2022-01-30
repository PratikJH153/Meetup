import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController editingController;
  final String label;
  final Function(String value) validatorHandler;
  final FocusNode focus;
  const TextFieldWidget({
    required this.editingController,
    required this.label,
    required this.validatorHandler,
    required this.focus,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 3,
        bottom: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFf0f2f7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: editingController,
        cursorColor: Colors.black,
        autofocus: false,
        focusNode: focus,
        validator: (value) => validatorHandler(value!),
        obscureText: label == "Password" ? true : false,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 20),
          hintStyle: const TextStyle(
            color: Color(0xFF404040),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
