import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kissanmitra/pallete.dart';
import 'package:path/path.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:kissanmitra/screens/widgets/background-image.dart';
import 'package:kissanmitra/screens/widgets/password-input.dart';
import 'package:kissanmitra/screens/widgets/rounded-button.dart';
import 'package:kissanmitra/screens/widgets/text-field-input.dart';
import 'package:kissanmitra/screens/widgets/widgets.dart';

class CreateNewAccount extends StatefulWidget {
  static var user = TextEditingController();
  static var email = TextEditingController();
  static var pass = TextEditingController();
  static var cpass = TextEditingController();

  static List<TextEditingController> myCreateController = [
    user,
    email,
    pass,
    cpass
  ];

  @override
  _CreateNewAccountState createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  File _image;
  bool uploaded = false;
  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    //print('Image Path : ${image.path}');
    image = await ImageCropper.cropImage(
      sourcePath: image.path,
      // maxHeight: 500,
      // maxWidth: 500,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
          lockAspectRatio: true,
          initAspectRatio: CropAspectRatioPreset.square,
          hideBottomControls: false),
    );

    return image;
  }

  TextEditingController dis = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (uploaded) return Scaffold(body: Statics.getLoadingScreen());
    precacheImage(AssetImage('assets/images/register_bg.jpg'), context);
    Size size = MediaQuery.of(context).size;
    String email, pass, cpass, name;
    List dists = [
      'Ahmedabad',
      'Amreli',
      'Anand',
      'Aravalli',
      'Banaskantha',
      'Bharuch',
      'Bhavnagar',
      'Botad',
      'Chhota Udaipur',
      'Dahod',
      'Dang',
      'Devbhoomi',
      'Gandhinagar',
      'Gir Somnath',
      'Jamnagar',
      'Junagadh',
      'Kutch',
      'Kheda',
      'Mahisagar',
      'Mehsana',
      'Morbi',
      'Narmada',
      'Navsari',
      'Panchmahal',
      'Patan',
      'Porbandar',
      'Rajkot',
      'Sabarkantha',
      'Surat',
      'Surendranagar',
      'Tapi',
      'Vadodara',
      'Valsad'
    ];
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/register_bg.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.width * 0.1,
                ),
                GestureDetector(
                  onTap: () async {
                    File _img = await getImage();
                    // Statics.showToast(img.path);
                    setState(() {
                      _image = _img;
                    });
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: ClipOval(
                          child: CircleAvatar(
                            backgroundImage:
                                (_image != null) ? FileImage(_image) : null,
                            radius: size.width * 0.14,
                            backgroundColor: Colors.grey[400].withOpacity(
                              0.4,
                            ),
                            child: (_image == null)
                                ? Icon(
                                    FontAwesomeIcons.user,
                                    color: kWhite,
                                    size: size.width * 0.1,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.08,
                        left: size.width * 0.56,
                        child: Container(
                          height: size.width * 0.1,
                          width: size.width * 0.1,
                          decoration: BoxDecoration(
                            color: kBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: kWhite, width: 2),
                          ),
                          child: Icon(
                            FontAwesomeIcons.arrowUp,
                            color: kWhite,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Column(
                  children: [
                    TextInputField(
                        icon: FontAwesomeIcons.user,
                        hint: 'નામ',
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        value: 0),
                    TextInputField(
                      icon: FontAwesomeIcons.envelope,
                      hint: 'Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      value: 1,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          child: Container(
                              height: size.height * 0.08,
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.grey[500].withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: TextFormField(
                                  controller: dis,
                                  onTap: () async {
                                    print("Clicked");
                                    var val = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: List.generate(
                                              dists.length,
                                              (index) => RadioListTile(
                                                title: Text(dists[index]),
                                                value: dists[index],
                                                groupValue: dis.text,
                                                onChanged: (val) {
                                                  Navigator.of(context)
                                                      .pop(val);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      print("Val : $val");
                                      dis.text = val.toString();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Icon(
                                        FontAwesomeIcons.searchLocation,
                                        size: 28,
                                        color: kWhite,
                                      ),
                                    ),
                                    hintText: "જીલ્લો",
                                    hintStyle: kBodyText,
                                  ),
                                  style: kBodyText,
                                  maxLines: 1,
                                  readOnly: true,
                                ),
                              )),
                        )),
                    PasswordInput(
                        icon: FontAwesomeIcons.lock,
                        hint: 'પાસવર્ડ',
                        inputAction: TextInputAction.next,
                        value: 2),
                    PasswordInput(
                        icon: FontAwesomeIcons.lock,
                        hint: 'પાસવર્ડની પુષ્ટિ કરો',
                        inputAction: TextInputAction.done,
                        value: 3),
                    SizedBox(
                      height: 25,
                    ),
                    RoundedButton(
                      buttonName: 'Register',
                      action: () async {
                        name = CreateNewAccount.myCreateController[0].text;
                        email = CreateNewAccount.myCreateController[1].text;
                        pass = CreateNewAccount.myCreateController[2].text;
                        cpass = CreateNewAccount.myCreateController[3].text;

                        if (name.isEmpty ||
                            email.isEmpty ||
                            pass.isEmpty ||
                            cpass.isEmpty ||
                            dis.text == null)
                          Statics.showToast("Fill All the Fields");
                        else if (pass != cpass)
                          Statics.showToast("Both Password Doesn't Mathches");
                        else {
                          uploadData(context);
                          setState(() {
                            uploaded = true;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'પહેલેથી જ ખાતું છે?',
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, '');
                          },
                          child: Text(
                            'Login',
                            style: kBodyText.copyWith(
                                color: kBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  uploadData(context) async {
    UserCredential user;
    try {
      String name = CreateNewAccount.myCreateController[0].text.trim();
      // await Firebase.initializeApp();
      String url;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: CreateNewAccount.email.text.trim(),
              password: CreateNewAccount.pass.text.trim())
          .then((value) async {
        user = value;
        await FirebaseStorage.instance
            .ref()
            .child("Users/${user.user.uid}/${basename(_image.path)}")
            .putFile(_image)
            .then((snap) async => url = await snap.ref.getDownloadURL());

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user.uid)
            .set({
          'name': name,
          'email': CreateNewAccount.email.text,
          'dp': url,
          'district': dis.text,
          "id": user.user.uid
        }).then((value) {
          Navigator.pop(context, 'created');
        });
      });
    } catch (e) {
      print(e);
      Statics.showToast("ERROR : $e");
      setState(() {
        uploaded = false;
      });
    }
  }
}
