import 'package:flutter/material.dart';
import 'package:meetupapp/helper/auth.dart';
import 'package:meetupapp/helper/user_db_helper.dart';
import 'package:meetupapp/models/user.dart';
import 'package:meetupapp/views/home.dart';
import 'package:meetupapp/widgets/appbar_widget.dart';
import 'package:meetupapp/widgets/auth_button.dart';
import 'package:meetupapp/widgets/textfield_widget.dart';

class UserDetailsRegisterPage extends StatefulWidget {
  static const routeName = "/userdetailsregister";
  const UserDetailsRegisterPage({Key? key}) : super(key: key);

  @override
  _UserDetailsRegisterPageState createState() =>
      _UserDetailsRegisterPageState();
}

class _UserDetailsRegisterPageState extends State<UserDetailsRegisterPage> {
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? arguements;

  void _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        final registeredUser = await AuthService.signUpWithEmailAndPassword(
            arguements!["email"], arguements!["password"], context);
        final user = User(
          userID: registeredUser.uid,
          username: arguements!["username"],
          email: arguements!["email"],
          gender: _genderController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          bio: _bioController.text.trim(),
          interests: [
            "Python",
            "Flutter",
            "Java",
            "Programming",
            "Learning",
          ],
        );

        await UserDBHelper.addUserData(user);

        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
      } catch (err) {
        print("GOT ERROR WHILE REGISTERING USER: " + err.toString());
      }
    }
  }

  //! ADD THIS FOR ACCESSING MODAL ROUTES
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  // }

  @override
  Widget build(BuildContext context) {
    arguements =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: appBar("UserDetailsRegisterPage"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AuthButton(
        label: "Register",
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
                  TextFieldWidget(_genderController, "Gender"),
                  TextFieldWidget(_ageController, "Age"),
                  TextFieldWidget(_bioController, "Bio")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
