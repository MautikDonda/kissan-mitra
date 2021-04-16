import 'package:flutter/material.dart';
import 'package:kissanmitra/main.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var dropdownvalue = '';
  var anim;

  @override
  void initState() {
    try {
      anim = Statics.pref.getString('loading');
    } catch (e) {
      Statics.pref.setString("loading", 'circle.json');
      anim = 'circle.json';
    }
    dropdownvalue = Statics.pref.getString("language");
    super.initState();
  }

  bool vis = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SwitchListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Text("Dark Theme"),
                  value: Statics.darkTheme,
                  onChanged: (val) async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setBool("dark", val);
                    setState(() {
                      Statics.darkTheme = val;
                      main();
                    });
                  }),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              ListTile(
                title: Text("Language"),
                trailing: DropdownButton(
                  value: dropdownvalue,
                  elevation: 16,
                  onChanged: (val) async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString("language", val);
                    setState(() {
                      dropdownvalue = val;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      child: Text("English"),
                      value: "en",
                    ),
                    DropdownMenuItem(
                      child: Text("Hindi"),
                      value: "hi",
                    ),
                    DropdownMenuItem(
                      child: Text("Gujarati"),
                      value: "guj",
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    vis = !vis;
                  });
                },
                title: Text("Loading Animation"),
                subtitle: Text('Tap to Change'),
              ),
              Visibility(
                visible: vis,
                child: AnimatedContainer(
                    curve: Curves.linear,
                    duration: Duration(seconds: 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: "circle.json",
                                    groupValue: anim,
                                    onChanged: (val) {
                                      Statics.pref.setString('loading', val);
                                      setState(() {
                                        anim = val;
                                      });
                                    }),
                                Text('Circle'),
                              ],
                            ),
                            SizedBox(
                                width: 130,
                                child:
                                    Lottie.asset('assets/lotties/circle.json'))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: "heart.json",
                                  groupValue: anim,
                                  onChanged: (val) {
                                    Statics.pref.setString('loading', val);
                                    setState(() {
                                      anim = val;
                                    });
                                  },
                                ),
                                Text('Heart'),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 38.0),
                              child: SizedBox(
                                  width: 50,
                                  child: Lottie.asset(
                                      'assets/lotties/heart.json')),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
/////////////////
