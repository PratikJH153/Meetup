import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController editingController;
  final Function(String value) validatorHandler;

  const SearchField({
    required this.editingController,
    required this.validatorHandler,
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
        validator: (value) => validatorHandler(value!),
        decoration: const InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: Color(0xFFb3b3b3),
          ),
          contentPadding: EdgeInsets.only(
            left: 10,
            top: 13,
          ),
          hintStyle: TextStyle(
            color: Color(0xFF5e5e5e),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
