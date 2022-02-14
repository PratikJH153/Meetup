import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetupapp/helper/utils/validator.dart';
import 'package:meetupapp/models/user.dart';
import 'package:meetupapp/providers/UserProvider.dart';
import 'package:meetupapp/widgets/constants.dart';
import 'package:meetupapp/widgets/drop_down_widget.dart';
import 'package:meetupapp/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = "/editprofilepage";
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String gendervalue = 'Male';
  int age = 20;

  late UserClass user;

  final genders = const [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  List<dynamic> _userInterests = [];

  bool _isLoadedInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isLoadedInit) {
      user = Provider.of<UserProvider>(
        context,
        listen: false,
      ).getUser()!;
      if (user != null) {
        firstNameController.text = user.firstname!;
        lastNameController.text = user.lastname!;
        nameController.text = user.username!;
        gendervalue = user.gender!;
        age = user.age!;
        bioController.text = user.bio!;
        _userInterests = user.interests!;
      }
      _isLoadedInit = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Profile",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              CupertinoIcons.arrow_left,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.checkmark_alt,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: user != null
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: kLeftPadding,
                    right: kRightPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 130,
                            width: 130,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFf0f0f0),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                user.profileURL!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF4265ff),
                                border: Border.all(
                                  width: 6,
                                  color: const Color(0xFFfafbff),
                                ),
                              ),
                              child: const Icon(
                                CupertinoIcons.pen,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              editingController: firstNameController,
                              label: "First Name",
                              validatorHandler: (val) =>
                                  Validator.validateTextField(result: val),
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
                                  Validator.validateTextField(result: val),
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
                            Validator.validateTextField(result: val),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropDownWidget(
                              items: genders,
                              value: gendervalue,
                              onChanged: (val) {
                                setState(() {
                                  gendervalue = val;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: AgePicker(
                              value: age,
                              onChanged: (val) {
                                setState(() {
                                  age = val;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        editingController: bioController,
                        label: "About me",
                        isBio: true,
                        validatorHandler: (val) {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Interests",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.add,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          children: user.interests!
                              .map(
                                (e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  margin: const EdgeInsets.only(
                                    right: 8,
                                    bottom: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF485563),
                                        Color(0xFF29323c),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.xmark_circle_fill,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        e,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}
