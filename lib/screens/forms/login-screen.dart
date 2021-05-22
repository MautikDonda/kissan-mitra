import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kissanmitra/pallete.dart';
import 'package:kissanmitra/screens/forms/create-new-account.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:kissanmitra/screens/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool click = false;
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/images/login_bg.jpg'), context);
    return Stack(
      children: [
        BackgroundImage(
          image: 'assets/images/login_bg.jpg',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: (!click)
              ? Column(
                  children: [
                    Flexible(
                      child: Center(
                        child: Text(
                          'કિસાનમિત્ર',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextInputField(
                          icon: FontAwesomeIcons.envelope,
                          hint: 'Email',
                          inputType: TextInputType.emailAddress,
                          inputAction: TextInputAction.next,
                          value: 1,
                        ),
                        PasswordInput(
                          icon: FontAwesomeIcons.lock,
                          hint: 'Password',
                          inputAction: TextInputAction.done,
                          value: 2,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, 'ForgotPassword'),
                          child: Text(
                            'પાસવર્ડ ભૂલી ગયા?',
                            style: kBodyText,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        RoundedButton(
                          action: () async {
                            String email =
                                CreateNewAccount.myCreateController[1].text;
                            String pass =
                                CreateNewAccount.myCreateController[2].text;
                            if (email.trim().isEmpty || pass.trim().isEmpty)
                              Statics.showToast("Fill all the Field");
                            else {
                              backgroundProcess(context);
                              setState(() {
                                click = true;
                              });
                            }
                          },
                          buttonName: 'Login',
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        var tmp = await Navigator.pushNamed(
                            context, '/CreateNewAccount');
                        if (tmp.toString() == 'create')
                          setState(() {
                            CreateNewAccount.pass.text = '';
                          });
                      },
                      child: Container(
                        child: Text(
                          'નવું ખાતું બનાવો',
                          style: kBodyText,
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(width: 1, color: kWhite))),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : Statics.getLoadingScreen(),
        )
      ],
    );
  }

  backgroundProcess(context) async {
    try {
      await Firebase.initializeApp();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: CreateNewAccount.myCreateController[1].text,
              password: CreateNewAccount.myCreateController[2].text)
          .then((value) async {
        CreateNewAccount.myCreateController[0].text = "";
        CreateNewAccount.myCreateController[1].text = "";
        CreateNewAccount.myCreateController[2].text = "";
        CreateNewAccount.myCreateController[3].text = "";
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user.uid)
            .get()
            .then((value) {
          Statics.email = value.data()['email'];
          Statics.name = value.data()['name'];
          Map data = value.data();
          CurrentUser.setData(
              data['id'], data['name'], data['email'], data['location']);
        });
        Navigator.of(context).pop('login');
      }).onError((error, stackTrace) {
        if (error.toString().contains("wrong-password")) {
          Statics.showToast("Wrong Password");
          setState(() {
            click = false;
          });
        } else if (error.toString().contains("user-not-found")) {
          Statics.showToast("No User Found!");
          setState(() {
            click = false;
          });
        } else {
          Statics.showToast(error.toString());
          setState(() {
            click = false;
          });
        }
        print(error.toString());
      });
    } catch (e) {
      print(e);
      Statics.showToast(e.toString());
      setState(() {
        click = false;
      });
    }
  }
}
