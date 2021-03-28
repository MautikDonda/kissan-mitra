import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kissanmitra/screens/widgets/inputField.dart';
import 'package:kissanmitra/screens/widgets/postCard.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class Blogs extends StatefulWidget {
  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  bool login;
  @override
  void initState() {
    try {
      Statics.getUid();
      login = true;
    } catch (e) {
      login = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (login)
        ? Scaffold(
            body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return PostCard(snapshot.data.docs[index].data());
                    },
                  );
                } else
                  return Statics.loading();
              },
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: "New Post",
              onPressed: () async {
                var res = await Navigator.of(context).pushNamed('newBlog');
                if (res.toString() == 'success') setState(() {});
              },
              child: LineIcon.facebookMessenger(),
            ),
          )
        : Scaffold(
            body: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'To Show and Give your Reaction to Posts, You must Login',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                        onPressed: () async {
                          var tmp = await Navigator.pushNamed(context, 'login');
                          if (tmp.toString() == 'login') {
                            setState(() {
                              login = true;
                            });
                          } else
                            Statics.showToast("Require Login");
                        },
                        child: Text("Login"))
                  ],
                ),
              ),
            ),
          );
  }
}
