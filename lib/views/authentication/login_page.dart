import 'package:flutter/material.dart';
import 'package:meetupapp/helper/auth.dart';
import 'package:meetupapp/helper/auth_provider.dart';
import 'package:meetupapp/views/authentication/register_page.dart';
import 'package:meetupapp/views/home.dart';
import 'package:meetupapp/widgets/appbar_widget.dart';
import 'package:meetupapp/widgets/auth_button.dart';
import 'package:meetupapp/widgets/textfield_widget.dart';
import 'package:provider/provider.dart';

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

  bool _isLoading = false;

  void _submit(BuildContext ctx) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        _isLoading = true;
      });
      form.save();
      try {
        await AuthService.loginWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          context,
        );
        setState(() {
          _isLoading = false;
        });

        Navigator.of(ctx)
            .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
      } catch (err) {
        setState(() {
          _isLoading = false;
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("LoginPage"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : AuthButton(
              label: "Login",
              onTapHandler: () => _submit(context),
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
              onPressed: () => Navigator.of(context).pushNamed(
                RegisterPage.routeName,
              ),
              child: const Text("Register Here"),
            ),
          ],
        ),
      ),
    );
  }
}
