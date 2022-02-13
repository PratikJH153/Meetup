import 'package:flutter/material.dart';
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
            label: "Email",
            validatorHandler: (val) => Validator.validateEmail(
              email: val,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFieldWidget(
            editingController: passwordController,
            label: "Password",
            validatorHandler: (val) => Validator.validatePassword(
              result: val,
            ),
          ),
        ],
      ),
    );
  }
}
