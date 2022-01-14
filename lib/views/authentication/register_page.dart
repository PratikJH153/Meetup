import 'package:flutter/material.dart';
import 'package:meetupapp/helper/auth.dart';
import 'package:meetupapp/views/authentication/user_details_register_page.dart';
import 'package:meetupapp/widgets/appbar_widget.dart';
import 'package:meetupapp/widgets/auth_button.dart';
import 'package:meetupapp/widgets/textfield_widget.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/register";
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      Navigator.pushNamed(context, UserDetailsRegisterPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("RegisterPage"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AuthButton(
        label: "Next",
        onTapHandler: _submit,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Register"),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFieldWidget(_usernameController, "Username"),
                  TextFieldWidget(_emailController, "Email"),
                  TextFieldWidget(_passwordController, "Password")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
