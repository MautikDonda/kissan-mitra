import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/main.dart';
import 'package:kissanmitra/screens/homescreen.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    Firebase.initializeApp();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/images/login_bg.jpg'), context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/login_bg.jpg'),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: FutureBuilder(
            future: initialization(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: Text(
                    'કિસાન મિત્ર',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else
                return Statics.loading();
            },
          ),
        ),
      ),
    );
  }

  initialization() async {
    try {
      try {
        WidgetsFlutterBinding.ensureInitialized();
      } catch (e) {
        Statics.showToast("Error : $e");
      }
      try {
        await Firebase.initializeApp();
      } catch (e) {
        Statics.showToast("Error : $e");
      }
      try {
        Statics.pref = await SharedPreferences.getInstance();
      } catch (e) {
        Statics.showToast("Error : $e");
      }
    } catch (e) {
      print('Error in initialization : $e');
    }
    try {
      Statics.darkTheme = Statics.pref.getBool("dark") ?? false;
      Statics.direction = Homescreen();
    } catch (e) {
      Statics.direction = StartingPage();
      Statics.pref.setBool("dark", false);
    }

    try {
      Statics.anim = Statics.pref.getString("loading");
      if (Statics.anim == null) {
        Statics.anim = "circle.json";
        Statics.pref.setString("loading", 'circle.json');
      }
    } catch (e) {
      Statics.pref.setString("loading", 'circle.json');
      Statics.anim = Statics.pref.getString("loading");
    }
    return Future.value(true);
  }
}
