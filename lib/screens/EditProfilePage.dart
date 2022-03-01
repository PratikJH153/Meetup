import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetupapp/helper/utils/loader.dart';
import 'package:meetupapp/screens/authentication/SelectInterestPage.dart';
import 'package:meetupapp/widgets/snackBar_widget.dart';
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
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 50,
    );

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
    final form = _editProfileKey.currentState;
    if (form!.validate()) {
      form.save();
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      String id = userProvider.getUser()!.userID!;

      setState(() {
        updatingNow = true;
      });

      if (userProvider.getUser()!.username!.trim().toLowerCase() !=
          usernameController.text.trim().toLowerCase()) {
        int isExists = await checkUsernameExists(
            context, usernameController.text.trim().toLowerCase());

        if (isExists == 1) {
          snackBarWidget(
            "Username Exists. Please try different username",
            const Color(0xFFff2954),
            context,
          );
          return;
        }
      }
      Map updateBody = {};
      String? url;
      if (image != null) {
        url = await uploadPic(id);
        if (url != null) {
          updateBody = {
            "firstname": firstNameController.text.trim(),
            "lastname": lastNameController.text.trim(),
            "gender": gendervalue,
            "age": age,
            "bio": bioController.text.trim(),
            "username": usernameController.text.trim(),
            "profileURL": url,
          };
        } else {
          updateBody = {
            "firstname": firstNameController.text.trim(),
            "lastname": lastNameController.text.trim(),
            "gender": gendervalue,
            "age": age,
            "bio": bioController.text.trim(),
            "username": usernameController.text.trim(),
          };
        }
      } else {
        updateBody = {
          "firstname": firstNameController.text.trim(),
          "lastname": lastNameController.text.trim(),
          "gender": gendervalue,
          "age": age,
          "bio": bioController.text.trim(),
          "username": usernameController.text.trim(),
        };
      }

      final updateResult = await UserAPIS.patchUser(id, updateBody);
      Map updateResultUnpacked = unPackLocally(updateResult);

      if (updateResultUnpacked["success"] == 1) {
        userProvider.updateUserInfo(
          firstname: firstNameController.text.trim(),
          lastname: lastNameController.text.trim(),
          username: usernameController.text.trim(),
          bio: bioController.text.trim(),
          age: age,
          gender: gendervalue,
          profileURL: updateBody.containsKey("profileURL")
              ? url ?? userProvider.getUser()!.profileURL
              : userProvider.getUser()!.profileURL,
        );
        Fluttertoast.showToast(msg: "Updated Profile successfully!");
      } else {
        Fluttertoast.showToast(msg: "Couldn't update Profile!");
        setState(() {
          updatingNow = false;
        });
        return;
      }
    }

    setState(() {
      updatingNow = false;
    });
    Navigator.of(context).pop();
  }

  final genders = const [
    'Male',
    'Female',
    'Other',
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
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
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
                                        height: 140,
                                        width: 140,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFf0f0f0),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: SizedBox(
                                          height: 140,
                                          width: 140,
                                          child: image == null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(55),
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
                                                      BorderRadius.circular(55),
                                                  child: Image.file(
                                                    image!,
                                                    fit: BoxFit.cover,
                                                  )),
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
                                                result: val.trim()),
                                        inputType: TextInputType.name,
                                        icon: CupertinoIcons.person_alt,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: TextFieldWidget(
                                        editingController: lastNameController,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        label: "Last Name",
                                        validatorHandler: (val) =>
                                            Validator.validateAuthFields(
                                                result: val.trim()),
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
                                      Validator.validateAuthFields(
                                          result: val.trim()),
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
                                      width: 15,
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
                                                const SelectInterestPage(),
                                          ),
                                        );
                                      },
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
                                  child: Consumer<UserProvider>(
                                    builder: (ctx, userProvider, _) {
                                      final user = userProvider.getUser();
                                      return Wrap(
                                        children: user!.interests!
                                            .map(
                                              (e) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 8,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  right: 8,
                                                  bottom: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey[200]!,
                                                      blurRadius: 5,
                                                      spreadRadius: 0.1,
                                                      offset:
                                                          const Offset(0, 2),
                                                    )
                                                  ],
                                                ),
                                                child: Text(
                                                  e.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      );
                                    },
                                  ),
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
