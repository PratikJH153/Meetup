import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/helper/utils/validator.dart';
import 'package:meetupapp/widgets/drop_down_widget.dart';
import 'package:meetupapp/widgets/text_field_widget.dart';

class Register3 extends StatelessWidget {
  final List<String> genders;
  final String genderValue;
  final Function onGenderTapHandler;
  final int age;
  final Function onAgeTapHandler;
  final TextEditingController bioController;
  const Register3({
    required this.genders,
    required this.genderValue,
    required this.onAgeTapHandler,
    required this.age,
    required this.onGenderTapHandler,
    required this.bioController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropDownWidget(
                  items: genders,
                  value: genderValue,
                  onChanged: (val) => onGenderTapHandler(val),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: AgePicker(
                  value: age,
                  onChanged: (val) => onAgeTapHandler(val),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          TextFieldWidget(
            editingController: bioController,
            textCapitalization: TextCapitalization.sentences,
            label: "About me",
            isBio: true,
            validatorHandler: (val) {},
            inputType: TextInputType.text,
            icon: CupertinoIcons.bold_italic_underline,
          ),
        ],
      ),
    );
  }
}
