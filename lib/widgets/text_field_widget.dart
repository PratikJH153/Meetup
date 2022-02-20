import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final IconData icon;
  final TextEditingController editingController;
  final String label;
  final bool isBio;
  final TextInputType inputType;
  final Function(String value) validatorHandler;
  const TextFieldWidget({
    required this.icon,
    required this.editingController,
    required this.label,
    required this.validatorHandler,
    required this.inputType,
    this.isBio = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 3,
        bottom: 3,
        left: 13,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFf5f5fc),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF949494),
          ),
          Expanded(
            child: TextFormField(
              controller: editingController,
              cursorColor: Colors.black,
              autofocus: false,
              maxLines: isBio ? null : 1,
              keyboardType: inputType,
              validator: (value) => validatorHandler(
                value!.trim(),
              ),
              obscureText: label == "Password" ? true : false,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 12),
                hintStyle: const TextStyle(
                  color: Color(0xFF404040),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
