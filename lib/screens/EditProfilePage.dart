import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/screens/authentication/SelectInterestPage.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '/helper/GlobalFunctions.dart';
import '/helper/backend/apis.dart';
import '/helper/backend/database.dart';
import '/helper/utils/validator.dart';
import '/models/UserClass.dart';
import '/providers/UserProvider.dart';
import '/widgets/constants.dart';
import '/widgets/drop_down_widget.dart';
import '/widgets/text_field_widget.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = "/editprofilepage";

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final _editProfileKey = GlobalKey<FormState>();

  void _imagePicker() async {
    ImagePicker _picker = ImagePicker();
    PickedFile? pickedFile =
        await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File pickedImage = File(pickedFile.path);
      setState(() {
        image = pickedImage;
      });
    }
  }

  Future<String> uploadPic(String uid) async {
    final ref =
        FirebaseStorage.instance.ref().child("user_images").child(uid + ".jpg");

    await ref.putFile(image!).whenComplete(() {
      print("Done");
    });

    final url = await ref.getDownloadURL();

    return url;
  }

  Future<void> _updateProfile() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String id = userProvider.getUser()!.userID!;

    setState(() {
      updatingNow = true;
    });

    Map updateBody = {
      "firstname": firstNameController.text,
      "lastname": lastNameController.text,
      "gender": gendervalue,
      "age": age,
      "bio": bioController.text,
      "interests": interests.keys.toList(),
      // "username": ,
    };

    final updateResult = await UserAPIS.patchUser(id, updateBody);
    Map updateResultUnpacked = unPackLocally(updateResult);

    if (updateResultUnpacked["success"] == 1) {
      userProvider.updateUserInfo(
        firstname: firstNameController.text,
        lastname: lastNameController.text,
        username: usernameController.text,
        bio: bioController.text,
        age: age,
        gender: gendervalue,
      );
      Fluttertoast.showToast(msg: "Updated Profile successfully!");
    } else {
      Fluttertoast.showToast(msg: "Couldn't update Profile!");
    }

    setState(() {
      updatingNow = false;
    });
  }

  final genders = const [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  bool updatingNow = false;
  bool madeAnyChanges = false;

  late String gendervalue;
  late String profileURL;
  int? age;

  File? image;
  Map interests = {};

  void changedSomething() {
    setState(() {
      madeAnyChanges = true;
    });
  }

  @override
  void initState() {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserClass user = userProvider.getUser()!;
    age = userProvider.getUser()!.age;
    gendervalue = userProvider.getUser()!.gender ?? "Undefined";

    for (var element in user.interests!) {
      interests[element] = true;
    }

    String _firstname = user.firstname ?? "Undefined";
    String _lastname = user.lastname ?? "Undefined";
    String _username = user.username ?? "Undefined";
    String _gender = user.gender ?? "Undefined";
    int _age = user.age ?? 0;
    String _bio = user.bio ?? "";
    String _profileUrl = user.profileURL ?? placeholder;

    firstNameController.text = _firstname;
    lastNameController.text = _lastname;
    usernameController.text = _username;
    bioController.text = _bio;
    gendervalue = _gender;
    profileURL = _profileUrl;
    age = _age;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserClass user = userProvider.getUser()!;

    return SafeArea(
      child: Scaffold(
        body: user != null
            ? updatingNow
                ? const GlobalLoader()
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 150),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        UpperWidgetOfBottomSheet(
                          tapHandler: _updateProfile,
                          icon: Icons.check,
                          toShow: true,
                          color: madeAnyChanges ? Colors.deepPurple : null,
                        ),
                        Form(
                          key: _editProfileKey,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: kLeftPadding,
                              right: kRightPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: _imagePicker,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 130,
                                        width: 130,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFf0f0f0),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: SizedBox(
                                          height: 130,
                                          width: 130,
                                          child: image == null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        "assets/images/placeholder.jpg",
                                                    image: profileURL,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.file(image!)),
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
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFieldWidget(
                                        editingController: firstNameController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        label: "First Name",
                                        validatorHandler: (val) =>
                                            Validator.validateAuthFields(
                                                result: val),
                                        inputType: TextInputType.name,
                                        icon: CupertinoIcons.person_alt,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Expanded(
                                      child: TextFieldWidget(
                                        editingController: lastNameController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        label: "Last Name",
                                        validatorHandler: (val) =>
                                            Validator.validateAuthFields(
                                                result: val),
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
                                  editingController: usernameController,
                                  textCapitalization: TextCapitalization.words,
                                  label: "Username",
                                  validatorHandler: (val) =>
                                      Validator.validateAuthFields(result: val),
                                  inputType: TextInputType.name,
                                  icon: CupertinoIcons.at_circle,
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
                                      height: 15,
                                    ),
                                    Expanded(
                                      child: AgePicker(
                                        value: age!,
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
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  label: "About me",
                                  isBio: true,
                                  validatorHandler: (val) {},
                                  inputType: TextInputType.text,
                                  icon: CupertinoIcons.bold_italic_underline,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Interests",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                SelectInterestPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.add,
                                      ),
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
                                            value: age!,
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                        children: interests.keys
                                            .toList()
                                            .map(
                                              (e) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    interests.remove(e);
                                                  });
                                                  userProvider.updateUserInfo(
                                                      interests: interests.keys
                                                          .toList());
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 14,
                                                    vertical: 8,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                    right: 8,
                                                    bottom: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    gradient:
                                                        const LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Color(0xFF485563),
                                                        Color(0xFF29323c),
                                                      ],
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        CupertinoIcons
                                                            .xmark_circle_fill,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        e.toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
            : Container(),
      ),
    );
  }
}
