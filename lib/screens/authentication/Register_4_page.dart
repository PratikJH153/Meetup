import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register4 extends StatelessWidget {
  final File? image;
  final VoidCallback tapHandler;
  const Register4({
    required this.image,
    required this.tapHandler,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: GestureDetector(
        onTap: tapHandler,
        child: Center(
          child: Stack(
            children: [
              Container(
                height: 170,
                width: 170,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFf0f0f0),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        CupertinoIcons.person_circle_fill,
                        size: 40,
                        color: Color(0xFF636363),
                      ),
              ),
              if (image == null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4265ff),
                      border: Border.all(
                        width: 6,
                        color: const Color(0xFFfafbff),
                      ),
                    ),
                    child: const Icon(
                      CupertinoIcons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
