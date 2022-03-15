import 'package:flutter/material.dart';

class AskDialogWidget extends StatelessWidget {
  final VoidCallback tapHandler;
  final String title;
  final String des;
  const AskDialogWidget({
    required this.tapHandler,
    required this.title,
    required this.des,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 1,
      title: Text(title),
      content: Text(
        des,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: tapHandler,
        ),
      ],
    );
  }
}

class DiscardAskDialogWidget extends StatelessWidget {
  final VoidCallback tapHandler;
  final String title;
  final String des;
  const DiscardAskDialogWidget({
    required this.tapHandler,
    required this.title,
    required this.des,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 1,
      title: Text(title),
      content: Text(
        des,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            return Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text("Discard"),
          onPressed: tapHandler,
        ),
      ],
    );
  }
}
