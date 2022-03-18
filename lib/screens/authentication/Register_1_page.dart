// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:meetupapp/helper/utils/validator.dart';
import 'package:meetupapp/widgets/text_field_widget.dart';

class Register1 extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const Register1({
    required this.emailController,
    required this.passwordController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          TextFieldWidget(
            editingController: emailController,
            textCapitalization: TextCapitalization.none,
            label: "Email",
            validatorHandler: (val) => Validator.validateEmail(
              email: val.trim(),
            ),
            icon: CupertinoIcons.mail_solid,
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 15,
          ),
          TextFieldWidget(
            editingController: passwordController,
            textCapitalization: TextCapitalization.none,
            label: "Password",
            validatorHandler: (val) => Validator.validatePassword(
              result: val.trim(),
            ),
            icon: CupertinoIcons.lock,
            inputType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }
}
