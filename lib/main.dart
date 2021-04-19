import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/routes.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

ThemeData _lightTheme = ThemeData(
  primarySwatch: Colors.green,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
ThemeData _darkTheme = ThemeData.dark();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color color1 = Colors.white;
  Color color2 = Colors.white;
  Color color3 = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'કિસાન મિત્ર',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: Statics.darkTheme ? _darkTheme : _lightTheme,
      routes: routes,
    );
  }
}

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Bapa ni Krupa"),
      ),
    );
  }
}

class StartingPage extends StatefulWidget {
  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  Color color1 = Colors.orangeAccent;
  Color color2 = Colors.grey;
  Color color3 = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.blueAccent.shade100,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  "language",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).pushNamed('/login');
                    setState(() {
                      color1 = Colors.orangeAccent;
                      color2 = Colors.grey;
                      color3 = Colors.grey;
                    });
                  },
                  child: Card(
                    color: color1,
                    elevation: 40,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: double.infinity,
                      // height: 20,
                      child: Text(
                        "English",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      color2 = Colors.orangeAccent;
                      color1 = Colors.grey;
                      color3 = Colors.grey;
                      print("Showa");
                    });
                    // Navigator.of(context).pushNamed('/login');
                  },
                  child: Card(
                    color: color2,
                    elevation: 40,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: double.infinity,
                      // height: 20,
                      child: Text(
                        "हिन्दी",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      color3 = Colors.orangeAccent;
                      color1 = Colors.grey;
                      color2 = Colors.grey;
                      print("Showa");
                    });
                    // Navigator.of(context).pushNamed('/login');
                  },
                  child: Card(
                    color: color3,
                    elevation: 40,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: double.infinity,
                      // height: 20,
                      child: Text(
                        "ગુજરાતી",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/greet');
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Greetings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "greeting",
                  style: TextStyle(fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/home', (route) => false);
                        // Navigator.of(context).pushNamed('/home');
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}