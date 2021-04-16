import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kissanmitra/screens/forms/login-screen.dart';
import 'package:kissanmitra/screens/homescreen_tabs/Agro/agro.dart';
import 'package:kissanmitra/screens/homescreen_tabs/Blog/blogs.dart';
import 'package:kissanmitra/screens/homescreen_tabs/History/AllHistory.dart';
import 'package:kissanmitra/screens/homescreen_tabs/Market/market.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:line_icons/line_icons.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Widget myListTile(title, icon, action) => ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontFamily: "Roboto"),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: icon,
        onTap: action,
      );

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    MarketingYard(),
    Blogs(),
    Agro(),
    AllHistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    bool login;

    try {
      Statics.getUid();
      // Statics.showToast(Statics.getUid());
      login = true;
    } catch (e) {
      login = false;
    }

    return WillPopScope(
      onWillPop: pop,
      child: Scaffold(
        appBar: AppBar(title: Text("KissanMitra"), actions: []),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  // color: Colors.grey,
                  rippleColor: Colors.grey[300],
                  // hoverColor: Colors.grey[100],
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100],
                  tabs: [
                    GButton(
                      icon: LineIcons.peopleCarry,
                      text: 'Market',
                    ),
                    GButton(
                      icon: LineIcons.blog,
                      text: 'Blog',
                    ),
                    GButton(
                      icon: LineIcons.shoppingBag,
                      text: 'Agro',
                    ),
                    GButton(
                      icon: LineIcons.history,
                      text: 'History',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              children: [
                myListTile(
                    "Soil",
                    Text(
                      '🏜',
                      style: TextStyle(fontSize: 25),
                    ), () {
                  Navigator.of(context).popAndPushNamed('soil');
                }),
                myListTile(
                    "Crops",
                    Text(
                      '🌱',
                      style: TextStyle(fontSize: 25),
                    ), () {
                  Navigator.of(context).popAndPushNamed('crops');
                }),
                myListTile(
                    "Machines",
                    Text(
                      '🚜',
                      style: TextStyle(fontSize: 25),
                    ), () {
                  Navigator.of(context).popAndPushNamed('machine');
                }),
                Divider(
                  thickness: 1.5,
                  indent: 10,
                  endIndent: 10,
                ),
                myListTile(
                  "Government Sites",
                  Icon(
                    Icons.web,
                    size: 30,
                  ),
                  () {
                    Navigator.of(context).popAndPushNamed('gov_site');
                  },
                ),
                Divider(
                  thickness: 1.5,
                  indent: 10,
                  endIndent: 10,
                ),
                myListTile(
                  "Settings",
                  Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  () {
                    Navigator.of(context).popAndPushNamed('settings');
                  },
                ),
                myListTile(
                  "Help",
                  Icon(
                    Icons.help,
                    size: 30,
                  ),
                  () {
                    Navigator.of(context).popAndPushNamed('help');
                  },
                ),
                Divider(
                  thickness: 1.5,
                  indent: 10,
                  endIndent: 10,
                ),
                Visibility(
                  visible: !login,
                  child: myListTile(
                    "Login",
                    Icon(
                      Icons.login,
                      size: 30,
                    ),
                    () async {
                      String tmp = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                      if (tmp == 'login')
                        setState(() {
                          login = false;
                        });
                    },
                  ),
                ),
                Visibility(
                  visible: login,
                  child: myListTile(
                    "Logout",
                    Icon(
                      Icons.logout,
                      size: 30,
                    ),
                    () async {
                      await FirebaseAuth.instance.signOut();
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Visibility(
                  visible: login,
                  child: myListTile(
                    "Profile",
                    Icon(
                      Icons.person,
                      size: 30,
                    ),
                    () {
                      Navigator.of(context).popAndPushNamed('profile');
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime currentBackPressTime;
  Future<bool> pop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      Statics.showToast("Press again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
