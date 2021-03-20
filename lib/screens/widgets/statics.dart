import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Statics {
  static BuildContext materialContext;
  static String name = '', email = '', pass = '', cpass = '';
  static Widget loading() {
    return CircularProgressIndicator();
  }

  static String anim;
  static SharedPreferences pref;
  static String getUid() => FirebaseAuth.instance.currentUser.uid;

  static Widget getLoadingScreen() {
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            // height: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lotties/${pref.getString('loading')}',
                    height: 200),
                Text(
                  "Loading...",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static bool login;

  static bool darkTheme;
  static void showToast(var msg1, {i = 0}) {
    Toast length = (i == 0) ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG;
    Fluttertoast.showToast(
        msg: msg1,
        // backgroundColor: HexColor("#2f1970"),
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 16,
        toastLength: length);
    print(msg1);
  }

  static Future<File> cropImage16() async {
    File tmp = await ImagePicker.pickImage(source: ImageSource.gallery);
    tmp = await ImageCropper.cropImage(
      compressQuality: 50,
      sourcePath: tmp.path,
      maxHeight: 500,
      maxWidth: 500,
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      androidUiSettings: AndroidUiSettings(
          lockAspectRatio: true,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          hideBottomControls: false),
    );
    return tmp;
  }
}

class User {
  static String name, email, location, id;
  static setData(String i, String n, String e, String l) {
    name = n;
    email = e;
    id = i;
    location = l;
  }
}
