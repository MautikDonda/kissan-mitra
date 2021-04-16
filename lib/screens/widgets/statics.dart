import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Statics {
  static List crops = [
    'ડાંગર',
    'વરીયાળી',
    'દિવેલા',
    'ગુવાર (ફોડર)',
    'દેશી કપાસ',
    'નાગલી	',
    'કપાસ',
    'મરચી',
    'તલ',
    'જુવાર',
    'સોયાબીન',
    'અડદ',
    'મકાઈ',
    'તુવેર',
    'બાજરી',
    'રજકો',
    'જીરું',
    'ધાણા',
    'ઘઉં',
    'મેથી',
    'ચણા',
    'ડુંગળી',
    'રાઇ',
    'ટામેટા',
    'બટાટા',
    'ઇસબગુલ',
    'ઓટ',
    'ગુવાર (શાક)',
    'ચોળી',
    'મગ',
    'મગફળી',
    'ભીંડા'
  ];
  static List dists = [
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

  static BuildContext materialContext;
  static String name = '', email = '', pass = '', cpass = '';
  static Widget loading() {
    return CircularProgressIndicator();
  }

  static String anim;
  static SharedPreferences pref;
  static String getUid() => FirebaseAuth.instance.currentUser.uid;
  static String yard = '';
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

  static Future<File> cropImage16(
      {CropAspectRatioPreset size = CropAspectRatioPreset.ratio16x9,
      int quality = 50}) async {
    File tmp = await ImagePicker.pickImage(source: ImageSource.gallery);
    tmp = await ImageCropper.cropImage(
      compressQuality: quality,
      sourcePath: tmp.path,
      maxHeight: 500,
      maxWidth: 500,
      // aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      androidUiSettings: AndroidUiSettings(
          lockAspectRatio: true,
          initAspectRatio: size,
          hideBottomControls: false),
    );
    return tmp;
  }

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

class CurrentUser {
  static String name, email, location, id;
  static setData(String i, String n, String e, String l) {
    name = n;
    email = e;
    id = i;
    location = l;
  }
}
