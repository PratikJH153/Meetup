import 'package:flutter/material.dart';
import 'package:meetupapp/helper/auth.dart';
import 'package:meetupapp/widgets/appbar_widget.dart';
import 'package:meetupapp/widgets/auth_button.dart';
import 'package:meetupapp/widgets/textfield_widget.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      AuthService.loginWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("LoginPage"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AuthButton(
        label: "Login",
        onTapHandler: _submit,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Login"),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFieldWidget(_emailController, "Email"),
                  TextFieldWidget(_passwordController, "Password")
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Register Here"),
            ),
          ],
        ),
      ),
    );
  }
}
