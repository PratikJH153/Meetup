import 'package:flutter/material.dart';
import 'package:meetupapp/widgets/appbar_widget.dart';
import 'package:meetupapp/widgets/textfield_widget.dart';

class UserDetailsRegisterPage extends StatefulWidget {
  static const routeName = "/userdetailsregister";
  const UserDetailsRegisterPage({Key? key}) : super(key: key);

  @override
  _UserDetailsRegisterPageState createState() =>
      _UserDetailsRegisterPageState();
}

class _UserDetailsRegisterPageState extends State<UserDetailsRegisterPage> {
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

  //Interests
  //Gender
  //Age
  //Bio
  //ProfilePic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("UserDetailsRegisterPage"),
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
