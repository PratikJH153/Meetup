import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetupapp/widgets/upper_widget_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '/helper/backend/apis.dart';
import '/helper/backend/database.dart';
import '/helper/utils/validator.dart';
import '/models/user.dart';
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

  final _user = UserAPIS();

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

  File? image;

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

    Map updateBody = {
      "firstname": firstNameController.text,
      "lastname": lastNameController.text,
      // "profileURL": ,
      "gender": gendervalue,
      "age": age,
      "bio": bioController.text,
      "interests": _userInterests,
      // "username": ,
    };

    final updateResult = await _user.patchUser(id, updateBody);
    Map updateResultUnpacked = unPackLocally(updateResult);

    if (updateResultUnpacked["success"] == 1) {
      Fluttertoast.showToast(msg: "Updated Profile successfully!");
    } else {
      Fluttertoast.showToast(msg: "Couldn't update Profile!");
    }
  }

  Map selectMap = {};

  @override
  void didChangeDependencies() {
    if (!_isLoadedInit) {
      user = Provider.of<UserProvider>(
        context,
        listen: false,
      ).getUser()!;
      firstNameController.text = user.firstname!;
      lastNameController.text = user.lastname!;
      usernameController.text = user.username!;
      gendervalue = user.gender!;
      age = user.age!;
      bioController.text = user.bio!;
      _userInterests = user.interests!;
      _isLoadedInit = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: user != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 150),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    UpperWidgetOfBottomSheet(
                      tapHandler: () {},
                      icon: Icons.check,
                      toShow: true,
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
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: SizedBox(
                                      height: 130,
                                      width: 130,
                                      child: image == null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/images/placeholder.jpg",
                                                image: user.profileURL!,
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
                                    label: "First Name",
                                    validatorHandler: (val) =>
                                        Validator.validateAuthFields(
                                            result: val),
                                    inputType: TextInputType.name,
                                    icon: CupertinoIcons.person_alt,
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
                              inputType: TextInputType.text,
                              icon: CupertinoIcons.bold_italic_underline,
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
                                      (e) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _userInterests.remove(e);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
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
                                                CupertinoIcons
                                                    .xmark_circle_fill,
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
                                      ),
                                    )
                                    .toList(),
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
