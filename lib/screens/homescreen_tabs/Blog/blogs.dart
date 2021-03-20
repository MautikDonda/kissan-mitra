import 'package:flutter/material.dart';
import 'package:kissanmitra/screens/widgets/statics.dart';
import 'package:line_icons/line_icon.dart';

class Blogs extends StatefulWidget {
  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            Statics.getUid();
            var res = await Navigator.of(context).pushNamed('newBlog');
            if (res.toString() == 'success') setState(() {});
          } catch (e) {
            var tmp = await Navigator.pushNamed(context, 'login');
            if (tmp.toString() == 'login') {
              var res = await Navigator.of(context).pushNamed('newBlog');
              if (res.toString() == 'success') setState(() {});
            } else {
              Statics.showToast("Login Required for Adding Data");
            }
          }
        },
        child: LineIcon.facebookMessenger(),
      ),
    );
  }
}
