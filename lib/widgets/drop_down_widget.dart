import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DropDownWidget extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function onChanged;
  const DropDownWidget({
    required this.value,
    required this.items,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 3,
        bottom: 3,
        left: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFf5f5fc),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton(
        elevation: 0,
        underline: const SizedBox(),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(15),
        onChanged: (String? newValue) => onChanged(newValue),
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}

class AgePicker extends StatelessWidget {
  final int value;
  final Function onChanged;
  const AgePicker({
    required this.value,
    required this.onChanged,
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
        color: const Color(0xFFf5f5fc),
        borderRadius: BorderRadius.circular(15),
      ),
      child: NumberPicker(
        value: value,
        textStyle: const TextStyle(
          color: Colors.grey,
        ),
        itemWidth: 53,
        minValue: 5,
        axis: Axis.horizontal,
        maxValue: 100,
        selectedTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (val) => onChanged(val),
      ),
    );
  }
}
