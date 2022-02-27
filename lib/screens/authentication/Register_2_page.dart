import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/helper/utils/validator.dart';
import 'package:meetupapp/widgets/text_field_widget.dart';

class Register2 extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController nameController;
  const Register2({
    required this.firstNameController,
    required this.lastNameController,
    required this.nameController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  editingController: firstNameController,
                  label: "First Name",
                  validatorHandler: (val) =>
                      Validator.validateAuthFields(result: val),
                  inputType: TextInputType.name,
                  icon: CupertinoIcons.person_alt,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFieldWidget(
                  editingController: lastNameController,
                  label: "Last Name",
                  validatorHandler: (val) =>
                      Validator.validateAuthFields(result: val),
                  inputType: TextInputType.name,
                  icon: CupertinoIcons.person_alt,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          TextFieldWidget(
            editingController: nameController,
            label: "Username",
            validatorHandler: (val) =>
                Validator.validateAuthFields(result: val),
            inputType: TextInputType.name,
            icon: CupertinoIcons.at_circle,
          ),
        ],
      ),
    );
  }
}
